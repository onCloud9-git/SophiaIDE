#!/usr/bin/env bash
set -euo pipefail
new_branch=${1:-sophia-next}
base=main
./scripts/update-main-from-upstream.sh
git checkout -B "$new_branch" "$base"
if compgen -G "patches/*.patch" > /dev/null; then git am --3way patches/*.patch || { echo "Patch apply failed. Resolve conflicts and run: git am --continue" >&2; exit 2; }; echo "Applied patches onto $new_branch"; else echo "No patches found in patches/" >&2; exit 1; fi
