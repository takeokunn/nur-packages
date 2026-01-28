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

    while IFS= read -r pkg; do
        if update_package_dispatch "$pkg"; then
            ((updated++)) || true
        else
            ((skipped++)) || true
        fi
        echo ""
    done < <(extract_packages)

    echo "=== Summary ==="
    echo "Updated: $updated"
    echo "Skipped: $skipped"
    echo "Completed at: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
}

main "$@"
