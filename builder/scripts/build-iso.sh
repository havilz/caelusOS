#!/bin/bash
set -e

log_info()    { echo -e "\e[34m[CAELUS-INFO]\e[0m $1"; }
log_success() { echo -e "\e[32m[CAELUS-SUCCESS]\e[0m $1"; }
log_error()   { echo -e "\e[31m[CAELUS-ERROR]\e[0m $1"; }

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BUILDER_DIR="$PROJECT_ROOT/builder"
OUT_DIR="$BUILDER_DIR/out"

log_info "Starting CaelusOS Live ISO Build Pipeline..."

mkdir -p "$OUT_DIR"
cd "$BUILDER_DIR"

log_info "1. Wiring seeds/*.seed into package-lists/caelus.list.chroot..."
# Remove legacy duplicate config path if present
if [ -d "$BUILDER_DIR/config/auto" ]; then
    rm -rf "$BUILDER_DIR/config/auto"
fi

mkdir -p "$BUILDER_DIR/config/package-lists"
LIST_FILE="$BUILDER_DIR/config/package-lists/caelus.list.chroot"
> "$LIST_FILE"

# Collect all seed packages excluding comments and blacklist
for seed in "$PROJECT_ROOT/seeds/core.seed" "$PROJECT_ROOT/seeds/desktop.seed" "$PROJECT_ROOT/seeds/apps.seed" "$PROJECT_ROOT/seeds/drivers.seed"; do
    if [ -f "$seed" ]; then
        grep -v '^\s*#' "$seed" | grep -v '^\s*$' >> "$LIST_FILE.raw" || true
    fi
done

# Filter out blacklist items
if [ -f "$PROJECT_ROOT/seeds/blacklist.seed" ]; then
    grep -v '^\s*#' "$PROJECT_ROOT/seeds/blacklist.seed" | grep -v '^\s*$' > "$BUILDER_DIR/blacklist.tmp" || true
    grep -v -F -f "$BUILDER_DIR/blacklist.tmp" "$LIST_FILE.raw" > "$LIST_FILE" 2>/dev/null || cp "$LIST_FILE.raw" "$LIST_FILE"
    rm -f "$BUILDER_DIR/blacklist.tmp" "$LIST_FILE.raw"
else
    mv "$LIST_FILE.raw" "$LIST_FILE"
fi
log_success "Package list generated at config/package-lists/caelus.list.chroot"

log_info "2. Synchronizing Overlay Packages..."
mkdir -p "$BUILDER_DIR/config/includes.chroot"
cp -r "$PROJECT_ROOT/packages/caelus-settings/"* "$BUILDER_DIR/config/includes.chroot/" 2>/dev/null || true
cp -r "$PROJECT_ROOT/packages/caelus-artwork/"* "$BUILDER_DIR/config/includes.chroot/" 2>/dev/null || true
cp -r "$PROJECT_ROOT/packages/caelus-plymouth/"* "$BUILDER_DIR/config/includes.chroot/" 2>/dev/null || true
cp -r "$PROJECT_ROOT/packages/caelus-welcome/"* "$BUILDER_DIR/config/includes.chroot/" 2>/dev/null || true

log_info "3. Executing Live-Build..."
if [ -f "$BUILDER_DIR/auto/config" ]; then
    chmod +x "$BUILDER_DIR/auto/config"
    ./auto/config
else
    lb config
fi

lb build

# Robust ISO file detection (matches live-image-amd64.iso, binary.hybrid.iso, or any generated .iso)
ISO_FOUND=$(find "$BUILDER_DIR" -maxdepth 1 -name "*.iso" | head -n1)

if [ -n "$ISO_FOUND" ] && [ -f "$ISO_FOUND" ]; then
    mv "$ISO_FOUND" "$OUT_DIR/caelusOS-live-amd64.iso"
    cd "$OUT_DIR"
    sha256sum caelusOS-live-amd64.iso > caelusOS-live-amd64.iso.sha256
    log_success "CaelusOS ISO generated successfully at: $OUT_DIR/caelusOS-live-amd64.iso"
else
    log_error "ISO generation failed. No ISO file generated in $BUILDER_DIR"
    exit 1
fi
