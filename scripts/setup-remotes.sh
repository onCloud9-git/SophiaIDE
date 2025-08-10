#!/usr/bin/env bash
set -euo pipefail
# usage: scripts/setup-remotes.sh <origin-url> <upstream-url>
origin=${1:-}
upstream=${2:-}
if [[ -z "$origin" || -z "$upstream" ]]; then
  echo "Usage: scripts/setup-remotes.sh <origin-url> <upstream-url>" >&2
  exit 1
fi
if git remote | grep -qx origin; then
  git remote set-url origin "$origin"
else
  git remote add origin "$origin"
fi
if git remote | grep -qx upstream; then
  git remote set-url upstream "$upstream"
else
  git remote add upstream "$upstream"
fi
git fetch --all --prune
# ensure main tracks origin/main if exists
if git ls-remote --exit-code origin main >/dev/null 2>&1; then
  git checkout -B main origin/main || git checkout -B main
fi
echo "Remotes configured."
