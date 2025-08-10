#!/usr/bin/env bash
set -euo pipefail
# Rebase feature branch (default: sophia) on updated main
branch=${1:-sophia}
base=main
current=$(git rev-parse --abbrev-ref HEAD)
./scripts/update-main-from-upstream.sh
if git rev-parse --verify "$branch" >/dev/null 2>&1; then
  git checkout "$branch"
else
  git checkout -B "$branch" "$base"
fi

git merge --no-ff "$base"
echo "Merged base into $branch"

if [[ "$current" != "$branch" ]]; then
  git checkout "$current"
fi
