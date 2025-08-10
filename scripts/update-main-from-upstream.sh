#!/usr/bin/env bash
set -euo pipefail
# Sync local main with upstream/main (fast-forward), without pushing
branch=main

git fetch upstream origin --prune
if git rev-parse --verify "$branch" >/dev/null 2>&1; then
  git checkout "$branch"
else
  git checkout -B "$branch"
fi

if git merge --ff-only "upstream/$branch"; then
  echo "Fast-forwarded $branch from upstream/$branch"
else
  echo "Non-FF update required. Consider rebase: git rebase upstream/$branch" >&2
  exit 2
fi
