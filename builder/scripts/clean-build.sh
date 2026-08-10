#!/bin/bash
set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BUILDER_DIR="$PROJECT_ROOT/builder"

echo "[CAELUS-INFO] Cleaning Live-Build temporary directories..."
cd "$BUILDER_DIR"

if command -v lb >/dev/null 2>&1; then
    lb clean --purge || true
fi

rm -rf .build chroot binary stage local cache 2>/dev/null || true
echo "[CAELUS-SUCCESS] Build environment cleaned."
