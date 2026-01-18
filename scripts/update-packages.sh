#!/usr/bin/env bash
set -euo pipefail

# Update all packages in this NUR repository using nix-update
# Requires: nix-update from nixpkgs

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

check_prerequisites() {
    if ! command -v nix-update >/dev/null 2>&1; then
        echo "ERROR: nix-update is not installed" >&2
        echo "Install with: nix-shell -p nix-update" >&2
        exit 1
    fi
}

# Extract package names from default.nix (supports hyphenated names)
extract_packages() {
    grep -E '^\s+[a-zA-Z][a-zA-Z0-9_-]*\s*=\s*pkgs\.callPackage' "$REPO_ROOT/default.nix" \
        | perl -pe 's/^\s+([a-zA-Z][a-zA-Z0-9_-]*)\s*=.*/$1/'
}

# Update a single package
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

main() {
    check_prerequisites

    echo "=== NUR Package Update Script ==="
    echo "Started at: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
    echo ""

    local updated=0
    local skipped=0

    while IFS= read -r pkg; do
        if update_package "$pkg"; then
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
