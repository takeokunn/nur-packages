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
    # Emacs packages
    "emacs-arto:arto-app/arto.el:main"
    "emacs-consult-tramp:Ladicle/consult-tramp:main"
    "emacs-explain-pause-mode:lastquestion/explain-pause-mode:master"
    "emacs-fish-repl:takeokunn/fish-repl.el:main"
    "emacs-mu4e-dashboard:rougier/mu4e-dashboard:main"
    "emacs-ob-fish:takeokunn/ob-fish:main"
    "emacs-ob-phpstan:emacs-php/ob-phpstan:main"
    "emacs-ob-racket:hasu/emacs-ob-racket:master"
    "emacs-ob-treesitter:takeokunn/ob-treesitter:main"
    "emacs-org-volume:akirak/org-volume:master"
    "emacs-ox-hatena:zonkyy/ox-hatena:master"
    "emacs-php-doc-block:moskalyovd/emacs-php-doc-block:master"
    "emacs-rainbow-csv:emacs-vs/rainbow-csv:master"
    "emacs-sudden-death:yewton/sudden-death.el:master"
    "emacs-systemd-mode:holomorph/systemd-mode:master"
    "emacs-typst-mode:Ziqi-Yang/typst-mode.el:main"
    "emacs-web-php-blade-mode:takeokunn/web-php-blade-mode:main"
    "emacs-warm-mode:smallwat3r/emacs-warm-mode:main"
    "emacs-zalgo-mode:nehrbash/zalgo-mode:main"
    # Fish packages
    "dracula-fish:dracula/fish:master"
    "fish-artisan-completion:adriaanzon/fish-artisan-completion:master"
    "fish-by-binds-yourself:atusy/by-binds-yourself:main"
    "fish-dart-completions:takeokunn/fish-dart-completions:main"
    "fish-ghq:decors/fish-ghq:master"
    "fish-nix-completions:kidonng/nix-completions.fish:master"
    "fish-nix-env:lilyball/nix-env.fish:master"
    # Theme packages
    "dracula-tig:dracula/tig:master"
    "dracula-sublime:dracula/sublime:master"
    "sublime-gleam:molnarmark/sublime-gleam:main"
    "sublime-justfile:nk9/just_sublime:main"
    # Vim packages
    "nvim-aibo:lambdalisue/nvim-aibo:main"
    "vim-skkeleton:vim-skk/skkeleton:main"
    "vim-skkeleton-azik:kei-s16/skkeleton-azik-kanatable:main"
    "vimdoc-ja:vim-jp/vimdoc-ja:master"
)

# Packages to skip in automated updates (require manual update or have special build complexity)
# Format: "nix-pkg-name"
SKIP_PACKAGES=(
    "lms"      # buildNpmPackage from GitHub with non-standard tags; update manually
    "lmstudio" # binary-only; no parseable release source
    "arto"     # multi-hash package (source + cargoArtifacts + pnpmDeps); update manually
    "swift-argument-parser" # source-only fetchFromGitHub; no pname for nix-update
    "swift-testing"         # source-only fetchFromGitHub; no pname for nix-update
    "swift-syntax"          # source-only fetchFromGitHub; no pname for nix-update
)

# --- GitHub API helper ---

# Authenticated GitHub API call.
# Priority: gh CLI (handles auth automatically) > GITHUB_TOKEN env var > unauthenticated.
# Unauthenticated calls are limited to 60/hour; authenticated calls get 5000/hour.
github_api() {
    local path="$1"
    if command -v gh >/dev/null 2>&1; then
        gh api "$path"
    elif [[ -n "${GITHUB_TOKEN:-}" ]]; then
        curl -sf -H "Authorization: token ${GITHUB_TOKEN}" "https://api.github.com/${path}"
    else
        curl -sf "https://api.github.com/${path}"
    fi
}

# --- Prerequisite check ---

check_prerequisites() {
    if ! command -v nix-update >/dev/null 2>&1; then
        echo "ERROR: nix-update is not installed" >&2
        echo "Install with: nix-shell -p nix-update" >&2
        exit 1
    fi
}

# --- Package list helpers ---

is_skip_package() {
    local pkg="$1"
    for entry in "${SKIP_PACKAGES[@]}"; do
        [[ "$entry" == "$pkg" ]] && return 0
    done
    return 1
}

is_npm_package() {
    local pkg="$1"
    for entry in "${NPM_PACKAGES[@]}"; do
        [[ "${entry%%:*}" == "$pkg" ]] && return 0
    done
    return 1
}

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

is_github_unstable_package() {
    local pkg="$1"
    for entry in "${GITHUB_UNSTABLE_PACKAGES[@]}"; do
        [[ "${entry%%:*}" == "$pkg" ]] && return 0
    done
    return 1
}

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

# --- Update functions ---

# Update a commit-pinned GitHub package to the latest commit on its branch
update_github_unstable_package() {
    local nix_pkg="$1"
    local info
    info=$(get_github_unstable_info "$nix_pkg")
    local owner_repo="${info%:*}"
    local owner="${owner_repo%%/*}"
    local repo="${owner_repo#*/}"
    local branch="${info##*:}"
    local default_nix="$REPO_ROOT/pkgs/$nix_pkg/default.nix"

    echo "Updating GitHub unstable package: $nix_pkg ($owner/$repo@$branch)"

    if [[ ! -f "$default_nix" ]]; then
        echo "  [ERROR] $default_nix not found"
        return 2
    fi

    local commit_info
    commit_info=$(github_api "repos/${owner}/${repo}/commits/${branch}")
    if [[ -z "$commit_info" ]]; then
        echo "  [ERROR] Could not fetch latest commit from GitHub"
        return 2
    fi

    local latest_sha
    latest_sha=$(echo "$commit_info" | jq -r '.sha')
    local commit_date
    commit_date=$(echo "$commit_info" | jq -r '.commit.committer.date' | perl -pe 's/T.*//')
    if [[ -z "$latest_sha" || "$latest_sha" == "null" ]]; then
        echo "  [ERROR] Could not extract commit SHA"
        return 2
    fi
    echo "  Latest commit: $latest_sha ($commit_date)"

    local current_rev
    current_rev=$(perl -ne 'print $1 if /^\s*rev\s*=\s*"([^"]+)"/' "$default_nix")
    if [[ -z "$current_rev" ]]; then
        echo "  [ERROR] Could not extract current rev"
        return 2
    fi
    echo "  Current rev: $current_rev"

    if [[ "$current_rev" == "$latest_sha" ]]; then
        echo "  [SKIP] Already at latest commit"
        return 1
    fi

    echo "  Updating $current_rev -> $latest_sha"
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
        return 2
    fi
    echo "  New hash: $new_hash"

    local new_version="unstable-${commit_date}"

    # Validate inputs before using in perl substitutions
    if [[ ! "$latest_sha" =~ ^[0-9a-f]{40}$ ]]; then
        echo "  [ERROR] Invalid commit SHA format: $latest_sha"
        return 2
    fi
    if [[ ! "$new_hash" =~ ^sha256-[A-Za-z0-9+/]+=*$ ]]; then
        echo "  [ERROR] Invalid hash format: $new_hash"
        return 2
    fi
    if [[ ! "$new_version" =~ ^unstable-[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "  [ERROR] Invalid version format: $new_version"
        return 2
    fi

    echo "  Updating default.nix..."
    perl -pi -e "s|version = \"[^\"]+\"|version = \"${new_version}\"|" "$default_nix"
    perl -pi -e "s|rev = \"[^\"]+\"|rev = \"${latest_sha}\"|" "$default_nix"
    perl -pi -e "s|hash = \"sha256-[^\"]+\"|hash = \"${new_hash}\"|" "$default_nix"

    echo "  [OK] $nix_pkg updated to $new_version ($latest_sha)"
    return 0
}

# Update an npm registry package to the latest published version
update_npm_package() {
    local nix_pkg="$1"
    local npm_pkg
    npm_pkg=$(get_npm_name "$nix_pkg")
    local pkg_dir="$REPO_ROOT/pkgs/$nix_pkg"
    local default_nix="$pkg_dir/default.nix"

    echo "Updating npm package: $nix_pkg ($npm_pkg)"

    if [[ ! -f "$default_nix" ]]; then
        echo "  [ERROR] $default_nix not found"
        return 2
    fi

    local current_version
    current_version=$(perl -ne 'print $1 if /^\s*version\s*=\s*"([^"]+)"/' "$default_nix")
    if [[ -z "$current_version" ]]; then
        echo "  [ERROR] Could not extract current version"
        return 2
    fi
    echo "  Current version: $current_version"

    local latest_version
    latest_version=$(curl -sf "https://registry.npmjs.org/${npm_pkg}" | jq -r '.["dist-tags"].latest' 2>/dev/null)
    if [[ -z "$latest_version" || "$latest_version" == "null" ]]; then
        echo "  [ERROR] Could not fetch latest version from npm"
        return 2
    fi
    echo "  Latest version: $latest_version"

    if [[ "$current_version" == "$latest_version" ]]; then
        echo "  [SKIP] Already at latest version"
        return 1
    fi

    echo "  Updating $current_version -> $latest_version"

    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap "rm -rf '$tmp_dir'" RETURN

    local tarball_url="https://registry.npmjs.org/${npm_pkg}/-/$(basename "$npm_pkg")-${latest_version}.tgz"
    echo "  Downloading tarball..."
    if ! curl -sfL "$tarball_url" -o "$tmp_dir/package.tgz"; then
        echo "  [ERROR] Failed to download tarball"
        return 2
    fi

    echo "  Calculating tarball hash..."
    local tarball_hash
    tarball_hash=$(nix store prefetch-file --json "file://$tmp_dir/package.tgz" 2>/dev/null | jq -r '.hash')
    if [[ -z "$tarball_hash" || "$tarball_hash" == "null" ]]; then
        tarball_hash=$(nix-prefetch-url "file://$tmp_dir/package.tgz" 2>/dev/null)
        tarball_hash=$(nix hash convert --hash-algo sha256 --to sri "$tarball_hash")
    fi
    echo "  Tarball hash: $tarball_hash"

    echo "  Generating package-lock.json..."
    tar xzf "$tmp_dir/package.tgz" -C "$tmp_dir"
    jq 'del(.devDependencies)' "$tmp_dir/package/package.json" > "$tmp_dir/package/package.json.tmp"
    mv "$tmp_dir/package/package.json.tmp" "$tmp_dir/package/package.json"

    if command -v npm >/dev/null 2>&1; then
        (cd "$tmp_dir/package" && npm install --package-lock-only --omit=dev --ignore-scripts 2>/dev/null)
    else
        nix shell nixpkgs#nodejs_22 -c npm install --prefix "$tmp_dir/package" --package-lock-only --omit=dev --ignore-scripts 2>/dev/null
    fi

    if [[ ! -f "$tmp_dir/package/package-lock.json" ]]; then
        echo "  [ERROR] Failed to generate package-lock.json"
        return 2
    fi

    echo "  Calculating npmDepsHash..."
    local npm_deps_hash
    npm_deps_hash=$(nix shell nixpkgs#prefetch-npm-deps -c prefetch-npm-deps "$tmp_dir/package/package-lock.json" 2>&1 | tail -1)
    if [[ -z "$npm_deps_hash" ]]; then
        echo "  [ERROR] Failed to calculate npmDepsHash"
        return 2
    fi
    echo "  npmDepsHash: $npm_deps_hash"

    # Validate inputs before using in perl substitutions
    if [[ ! "$latest_version" =~ ^[0-9]+\.[0-9]+(\.[0-9]+)?([.+-][A-Za-z0-9._+-]*)?$ ]]; then
        echo "  [ERROR] Invalid npm version format: $latest_version"
        return 2
    fi
    if [[ ! "$tarball_hash" =~ ^sha256-[A-Za-z0-9+/]+=*$ ]]; then
        echo "  [ERROR] Invalid tarball hash format: $tarball_hash"
        return 2
    fi
    if [[ ! "$npm_deps_hash" =~ ^sha256-[A-Za-z0-9+/]+=*$ ]]; then
        echo "  [ERROR] Invalid npmDepsHash format: $npm_deps_hash"
        return 2
    fi

    echo "  Updating default.nix..."
    perl -pi -e "s/version = \"[^\"]+\"/version = \"$latest_version\"/" "$default_nix"
    perl -pi -e "s|hash = \"sha256-[^\"]+\"|hash = \"$tarball_hash\"|" "$default_nix"
    perl -pi -e "s|npmDepsHash = \"sha256-[^\"]+\"|npmDepsHash = \"$npm_deps_hash\"|" "$default_nix"
    cp "$tmp_dir/package/package-lock.json" "$pkg_dir/package-lock.json"

    echo "  [OK] $nix_pkg updated to $latest_version"
    return 0
}

# Update a versioned package using nix-update
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

# Dispatch a package to the appropriate update strategy
update_package_dispatch() {
    local pkg="$1"

    if is_skip_package "$pkg"; then
        echo "Skipping: $pkg (manual update required)"
        return 1
    elif is_npm_package "$pkg"; then
        update_npm_package "$pkg"
    elif is_github_unstable_package "$pkg"; then
        update_github_unstable_package "$pkg"
    else
        update_package "$pkg"
    fi
}

# Extract all package names from default.nix
extract_packages() {
    grep -E '^\s+[a-zA-Z][a-zA-Z0-9_-]*\s*=\s*pkgs\.callPackage' "$REPO_ROOT/default.nix" \
        | perl -pe 's/^\s+([a-zA-Z][a-zA-Z0-9_-]*)\s*=.*/$1/'
}

main() {
    check_prerequisites

    echo "=== NUR Package Update Script ==="
    echo "Started at: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
    echo ""

    local updated=0
    local skipped=0
    local failed=0

    echo "=== Updating Packages ==="
    while IFS= read -r pkg; do
        local rc=0
        update_package_dispatch "$pkg" || rc=$?
        if [[ $rc -eq 0 ]]; then
            ((updated++)) || true
        elif [[ $rc -eq 2 ]]; then
            ((failed++)) || true
        else
            ((skipped++)) || true
        fi
        echo ""
    done < <(extract_packages)

    echo "=== Summary ==="
    echo "Packages updated: $updated"
    echo "Packages skipped: $skipped"
    echo "Packages failed:  $failed"
    echo "Completed at: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
}

main "$@"
