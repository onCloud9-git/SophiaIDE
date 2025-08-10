#!/usr/bin/env bash
set -euo pipefail
# Run CI-like checks after sync/rebase (placeholder)
if command -v pnpm >/dev/null 2>&1; then
  pnpm install --frozen-lockfile || true
  pnpm test || { echo "Tests failed" >&2; exit 3; }
else
  echo "pnpm not found, skipping tests."
fi
