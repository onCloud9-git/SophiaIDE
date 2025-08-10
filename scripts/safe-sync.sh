#!/usr/bin/env bash
set -euo pipefail
feature=${1:-sophia}
./scripts/update-main-from-upstream.sh
./scripts/rebase-feature-on-main.sh "$feature"
./scripts/ci-checks.sh
echo "Safe sync completed. Push feature via: git push -u origin $feature"
