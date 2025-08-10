#!/usr/bin/env bash
set -euo pipefail
feature=${1:-sophia}

./scripts/update-main-from-upstream.sh
./scripts/rebase-feature-on-main.sh "$feature"
./scripts/ci-checks.sh

echo "Safe sync completed. Create PRs instead of pushing main."
echo "To push feature branch: git push -u origin $feature"
