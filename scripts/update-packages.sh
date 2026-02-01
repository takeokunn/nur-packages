#!/usr/bin/env bash
set -euo pipefail

# Update all packages in this NUR repository using nix-update
# Requires: nix-update from nixpkgs
#
# For packages without public repositories (e.g., npm-only packages),
# custom update functions are used instead of nix-update.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# npm packages that need custom update logic
# Format: "nix-pkg-name:npm-package-name"
NPM_PACKAGES=(
    "z_ai-coding-helper:@z_ai/coding-helper"
)

# GitHub packages with unstable versions (commit-based)
# Format: "nix-pkg-name:owner/repo:branch"
GITHUB_UNSTABLE_PACKAGES=(
    "emacs-arto:arto-app/arto.el:main"
)

# Flake inputs that track GitHub releases
# Format: "input-name:owner/repo"
FLAKE_RELEASE_INPUTS=(
    "arto:arto-app/arto"
)

check_prerequisites() {
    if ! command -v nix-update >/dev/null 2>&1; then
        echo "ERROR: nix-update is not installed" >&2
        echo "Install with: nix-shell -p nix-update" >&2
        exit 1
    fi
}

# Check if package is in npm packages list
is_npm_package() {
    local pkg="$1"
    for entry in "${NPM_PACKAGES[@]}"; do
        if [[ "${entry%%:*}" == "$pkg" ]]; then
            return 0
        fi
    done
    return 1
}

# Get npm package name for a nix package
get_npm_name() {
    local pkg="$1"
    for entry in "${NPM_PACKAGES[@]}"; do
        if [[ "${entry%%:*}" == "$pkg" ]]; then
            echo "${entry#*:}"
            return 0
        fi
    done
    return 1
}

# Check if package is in github unstable packages list
is_github_unstable_package() {
    local pkg="$1"
    for entry in "${GITHUB_UNSTABLE_PACKAGES[@]}"; do
        if [[ "${entry%%:*}" == "$pkg" ]]; then
            return 0
        fi
    done
    return 1
}

# Get owner/repo/branch for a github unstable package
get_github_unstable_info() {
    local pkg="$1"
    for entry in "${GITHUB_UNSTABLE_PACKAGES[@]}"; do
        if [[ "${entry%%:*}" == "$pkg" ]]; then
            echo "${entry#*:}"
            return 0
        fi
    done
    return 1
}

# Update github unstable package from latest commit
update_github_unstable_package() {
    local nix_pkg="$1"
    local info
    info=$(get_github_unstable_info "$nix_pkg")
    local owner_repo="${info%:*}"
    local owner="${owner_repo%%/*}"
    local repo="${owner_repo#*/}"
    local branch="${info##*:}"
    local pkg_dir="$REPO_ROOT/pkgs/$nix_pkg"
    local default_nix="$pkg_dir/default.nix"

    echo "Updating GitHub unstable package: $nix_pkg ($owner/$repo@$branch)"

    if [[ ! -f "$default_nix" ]]; then
        echo "  [ERROR] $default_nix not found"
        return 1
    fi

    # Get latest commit from GitHub API
    local commit_info
    commit_info=$(curl -sf "https://api.github.com/repos/${owner}/${repo}/commits/${branch}")
    if [[ -z "$commit_info" ]]; then
        echo "  [ERROR] Could not fetch latest commit from GitHub"
        return 1
    fi

    local latest_sha
    latest_sha=$(echo "$commit_info" | jq -r '.sha')
    local commit_date
    commit_date=$(echo "$commit_info" | jq -r '.commit.committer.date' | perl -pe 's/T.*//')
    if [[ -z "$latest_sha" || "$latest_sha" == "null" ]]; then
        echo "  [ERROR] Could not extract commit SHA"
        return 1
    fi
    echo "  Latest commit: $latest_sha ($commit_date)"

    # Extract current rev from default.nix
    local current_rev
    current_rev=$(perl -ne 'print $1 if /^\s*rev\s*=\s*"([^"]+)"/' "$default_nix")
    if [[ -z "$current_rev" ]]; then
        echo "  [ERROR] Could not extract current rev"
        return 1
    fi
    echo "  Current rev: $current_rev"

    # Compare revs
    if [[ "$current_rev" == "$latest_sha" ]]; then
        echo "  [SKIP] Already at latest commit"
        return 1
    fi

    echo "  Updating $current_rev -> $latest_sha"

    # Calculate new hash using nix-prefetch-github
    echo "  Calculating hash..."
    local prefetch_result
    if command -v nix-prefetch-github >/dev/null 2>&1; then
        prefetch_result=$(nix-prefetch-github "$owner" "$repo" --rev "$latest_sha" 2>/dev/null)
    else
        prefetch_result=$(nix shell nixpkgs#nix-prefetch-github -c nix-prefetch-github "$owner" "$repo" --rev "$latest_sha" 2>/dev/null)
    fi

    local new_hash
    new_hash=$(echo "$prefetch_result" | jq -r '.hash // .sha256')
    if [[ -z "$new_hash" || "$new_hash" == "null" ]]; then
        echo "  [ERROR] Failed to calculate hash"
        return 1
    fi
    echo "  New hash: $new_hash"

    # Update default.nix
    local new_version="unstable-${commit_date}"
    echo "  Updating default.nix..."
    perl -pi -e "s|version = \"unstable-[^\"]+\"|version = \"${new_version}\"|" "$default_nix"
    perl -pi -e "s|rev = \"[^\"]+\"|rev = \"${latest_sha}\"|" "$default_nix"
    perl -pi -e "s|hash = \"sha256-[^\"]+\"|hash = \"${new_hash}\"|" "$default_nix"

    echo "  [OK] $nix_pkg updated to $new_version ($latest_sha)"
    return 0
}

# Update npm package from registry
update_npm_package() {
    local nix_pkg="$1"
    local npm_pkg
    npm_pkg=$(get_npm_name "$nix_pkg")
    local pkg_dir="$REPO_ROOT/pkgs/$nix_pkg"
    local default_nix="$pkg_dir/default.nix"

    echo "Updating npm package: $nix_pkg ($npm_pkg)"

    if [[ ! -f "$default_nix" ]]; then
        echo "  [ERROR] $default_nix not found"
        return 1
    fi

    # Get current version from default.nix
    local current_version
    current_version=$(perl -ne 'print $1 if /^\s*version\s*=\s*"([^"]+)"/' "$default_nix")
    if [[ -z "$current_version" ]]; then
        echo "  [ERROR] Could not extract current version"
        return 1
    fi
    echo "  Current version: $current_version"

    # Get latest version from npm registry
    local npm_url="https://registry.npmjs.org/${npm_pkg}"
    local latest_version
    latest_version=$(curl -sf "$npm_url" | jq -r '.["dist-tags"].latest' 2>/dev/null)
    if [[ -z "$latest_version" || "$latest_version" == "null" ]]; then
        echo "  [ERROR] Could not fetch latest version from npm"
        return 1
    fi
    echo "  Latest version: $latest_version"

    # Compare versions
    if [[ "$current_version" == "$latest_version" ]]; then
        echo "  [SKIP] Already at latest version"
        return 1
    fi

    echo "  Updating $current_version -> $latest_version"

    # Create temp directory for work
    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap "rm -rf '$tmp_dir'" RETURN

    # Download and extract new tarball
    local tarball_url="https://registry.npmjs.org/${npm_pkg}/-/$(basename "$npm_pkg")-${latest_version}.tgz"
    echo "  Downloading tarball..."
    if ! curl -sfL "$tarball_url" -o "$tmp_dir/package.tgz"; then
        echo "  [ERROR] Failed to download tarball"
        return 1
    fi

    # Calculate tarball hash
    echo "  Calculating tarball hash..."
    local tarball_hash
    tarball_hash=$(nix store prefetch-file --json "file://$tmp_dir/package.tgz" 2>/dev/null | jq -r '.hash')
    if [[ -z "$tarball_hash" || "$tarball_hash" == "null" ]]; then
        tarball_hash=$(nix-prefetch-url "file://$tmp_dir/package.tgz" 2>/dev/null)
        tarball_hash=$(nix hash convert --hash-algo sha256 --to sri "$tarball_hash")
    fi
    echo "  Tarball hash: $tarball_hash"

    # Extract tarball and generate package-lock.json
    echo "  Generating package-lock.json..."
    tar xzf "$tmp_dir/package.tgz" -C "$tmp_dir"

    # Remove devDependencies from package.json to avoid fetching dev deps
    if command -v jq >/dev/null 2>&1; then
        jq 'del(.devDependencies)' "$tmp_dir/package/package.json" > "$tmp_dir/package/package.json.tmp"
        mv "$tmp_dir/package/package.json.tmp" "$tmp_dir/package/package.json"
    else
        nix shell nixpkgs#jq -c jq 'del(.devDependencies)' "$tmp_dir/package/package.json" > "$tmp_dir/package/package.json.tmp"
        mv "$tmp_dir/package/package.json.tmp" "$tmp_dir/package/package.json"
    fi

    # Generate package-lock.json with production deps only
    if command -v npm >/dev/null 2>&1; then
        (cd "$tmp_dir/package" && npm install --package-lock-only --omit=dev --ignore-scripts 2>/dev/null)
    else
        nix shell nixpkgs#nodejs_22 -c npm install --prefix "$tmp_dir/package" --package-lock-only --omit=dev --ignore-scripts 2>/dev/null
    fi

    if [[ ! -f "$tmp_dir/package/package-lock.json" ]]; then
        echo "  [ERROR] Failed to generate package-lock.json"
        return 1
    fi

    # Calculate npmDepsHash
    echo "  Calculating npmDepsHash..."
    local npm_deps_hash
    npm_deps_hash=$(nix shell nixpkgs#prefetch-npm-deps -c prefetch-npm-deps "$tmp_dir/package/package-lock.json" 2>&1 | tail -1)
    if [[ -z "$npm_deps_hash" ]]; then
        echo "  [ERROR] Failed to calculate npmDepsHash"
        return 1
    fi
    echo "  npmDepsHash: $npm_deps_hash"

    # Update default.nix
    echo "  Updating default.nix..."
    perl -pi -e "s/version = \"[^\"]+\"/version = \"$latest_version\"/" "$default_nix"
    perl -pi -e "s|hash = \"sha256-[^\"]+\"|hash = \"$tarball_hash\"|" "$default_nix"
    perl -pi -e "s|npmDepsHash = \"sha256-[^\"]+\"|npmDepsHash = \"$npm_deps_hash\"|" "$default_nix"

    # Copy new package-lock.json
    cp "$tmp_dir/package/package-lock.json" "$pkg_dir/package-lock.json"

    echo "  [OK] $nix_pkg updated to $latest_version"
    return 0
}

# Update flake input that tracks GitHub releases
update_flake_release_input() {
    local input_name="$1"
    local owner_repo="$2"
    local owner="${owner_repo%%/*}"
    local repo="${owner_repo#*/}"
    local flake_nix="$REPO_ROOT/flake.nix"

    echo "Updating flake input: $input_name ($owner/$repo)"

    # Get latest release from GitHub API
    local release_info
    release_info=$(curl -sf "https://api.github.com/repos/${owner}/${repo}/releases/latest")
    if [[ -z "$release_info" ]]; then
        echo "  [ERROR] Could not fetch latest release from GitHub"
        return 1
    fi

    local latest_tag
    latest_tag=$(echo "$release_info" | jq -r '.tag_name')
    if [[ -z "$latest_tag" || "$latest_tag" == "null" ]]; then
        echo "  [ERROR] Could not extract release tag"
        return 1
    fi
    echo "  Latest release: $latest_tag"

    # Extract current version from flake.nix
    local current_tag
    current_tag=$(perl -ne "print \$1 if /^\s*${input_name}\s*=\s*\{[^}]*url\s*=\s*\"github:${owner}\/${repo}\/([^\"]+)\"/" "$flake_nix")
    if [[ -z "$current_tag" ]]; then
        # Try multiline pattern
        current_tag=$(perl -0777 -ne "print \$1 if /${input_name}\s*=\s*\{[^}]*url\s*=\s*\"github:[^\/]+\/[^\/]+\/([^\"]+)\"/" "$flake_nix")
    fi
    if [[ -z "$current_tag" ]]; then
        echo "  [ERROR] Could not extract current tag from flake.nix"
        return 1
    fi
    echo "  Current tag: $current_tag"

    # Compare versions
    if [[ "$current_tag" == "$latest_tag" ]]; then
        echo "  [SKIP] Already at latest release"
        return 1
    fi

    echo "  Updating $current_tag -> $latest_tag"

    # Update flake.nix
    perl -pi -e "s|github:${owner}/${repo}/[^\"]+|github:${owner}/${repo}/${latest_tag}|" "$flake_nix"

    echo "  [OK] flake input $input_name updated to $latest_tag"
    return 0
}

# Update all flake release inputs
update_flake_inputs() {
    local updated=0

    echo "=== Updating Flake Inputs ==="
    for entry in "${FLAKE_RELEASE_INPUTS[@]}"; do
        local input_name="${entry%%:*}"
        local owner_repo="${entry#*:}"
        if update_flake_release_input "$input_name" "$owner_repo"; then
            ((updated++)) || true
        fi
        echo ""
    done

    return $updated
}

# Extract package names from default.nix (supports hyphenated names)
extract_packages() {
    grep -E '^\s+[a-zA-Z][a-zA-Z0-9_-]*\s*=\s*pkgs\.callPackage' "$REPO_ROOT/default.nix" \
        | perl -pe 's/^\s+([a-zA-Z][a-zA-Z0-9_-]*)\s*=.*/$1/'
}

# Update a single package using nix-update
update_package() {
    local pkg="$1"
    echo "Updating: $pkg"

    if nix-update -f "$REPO_ROOT/default.nix" "$pkg" 2>&1; then
        echo "  [OK] $pkg updated successfully"
        return 0
    else
        echo "  [SKIP] $pkg - no updates or error"
        return 1
    fi
}

# Update a single package (dispatch to appropriate method)
update_package_dispatch() {
    local pkg="$1"

    if is_npm_package "$pkg"; then
        update_npm_package "$pkg"
    elif is_github_unstable_package "$pkg"; then
        update_github_unstable_package "$pkg"
    else
        update_package "$pkg"
    fi
}

main() {
    check_prerequisites

    echo "=== NUR Package Update Script ==="
    echo "Started at: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
    echo ""

    local updated=0
    local skipped=0
    local flake_updated=0

    # Update flake inputs first
    if update_flake_inputs; then
        flake_updated=$?
    fi

    echo "=== Updating Packages ==="
    while IFS= read -r pkg; do
        if update_package_dispatch "$pkg"; then
            ((updated++)) || true
        else
            ((skipped++)) || true
        fi
        echo ""
    done < <(extract_packages)

    echo "=== Summary ==="
    echo "Flake inputs updated: $flake_updated"
    echo "Packages updated: $updated"
    echo "Packages skipped: $skipped"
    echo "Completed at: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"

    # Run nix flake update if any flake inputs were updated
    if [[ $flake_updated -gt 0 ]]; then
        echo ""
        echo "=== Running nix flake update ==="
        nix flake update
    fi
}

main "$@"
