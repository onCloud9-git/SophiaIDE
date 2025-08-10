#!/usr/bin/env bash
set -euo pipefail
mkdir -p patches
base=origin/main
feature=${1:-sophia}
range="$base..$feature"
if ! git rev-parse --verify "$feature" >/dev/null 2>&1; then echo "Feature branch $feature not found" >&2; exit 1; fi
rm -f patches/*.patch 2>/dev/null || true
git format-patch --base=auto --output-directory patches $range
ls -1 patches/*.patch 2>/dev/null || echo "No patches generated (no diff)."
