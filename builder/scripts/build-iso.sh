#!/bin/bash
set -e

log_info()  { echo -e "\e[34m[CAELUS-INFO]\e[0m $1"; }
log_success() { echo -e "\e[32m[CAELUS-SUCCESS]\e[0m $1"; }
log_error() { echo -e "\e[31m[CAELUS-ERROR]\e[0m $1"; }

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BUILDER_DIR="$PROJECT_ROOT/builder"
OUT_DIR="$BUILDER_DIR/out"

log_info "Starting CaelusOS Live ISO Build Pipeline..."

mkdir -p "$OUT_DIR"
cd "$BUILDER_DIR"

log_info "Synchronizing Overlay Packages..."
mkdir -p "$BUILDER_DIR/config/includes.chroot"
cp -r "$PROJECT_ROOT/packages/caelus-settings/"* "$BUILDER_DIR/config/includes.chroot/" 2>/dev/null || true
cp -r "$PROJECT_ROOT/packages/caelus-artwork/"* "$BUILDER_DIR/config/includes.chroot/" 2>/dev/null || true
cp -r "$PROJECT_ROOT/packages/caelus-plymouth/"* "$BUILDER_DIR/config/includes.chroot/" 2>/dev/null || true
cp -r "$PROJECT_ROOT/packages/caelus-welcome/"* "$BUILDER_DIR/config/includes.chroot/" 2>/dev/null || true

log_info "Executing Live-Build..."
lb config
lb build

if [ -f "live-image-amd64.hybrid.iso" ]; then
    mv live-image-amd64.hybrid.iso "$OUT_DIR/caelusOS-live-amd64.iso"
    cd "$OUT_DIR"
    sha256sum caelusOS-live-amd64.iso > caelusOS-live-amd64.iso.sha256
    log_success "CaelusOS ISO generated successfully at: $OUT_DIR/caelusOS-live-amd64.iso"
else
    log_error "ISO generation failed."
    exit 1
fi
