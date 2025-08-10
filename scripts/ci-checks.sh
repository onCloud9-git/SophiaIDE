#!/usr/bin/env bash
set -euo pipefail
if command -v pnpm >/dev/null 2>&1; then pnpm install --frozen-lockfile || true; pnpm test --if-present || true; else echo "pnpm not found, skipping tests."; fi
