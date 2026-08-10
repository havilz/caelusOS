#!/bin/bash
set -e

ISO_PATH="${1:-../out/caelusOS-live-amd64.iso}"

if [ ! -f "$ISO_PATH" ]; then
    echo "[CAELUS-ERROR] Target ISO file '$ISO_PATH' not found."
    echo "Usage: ./test-qemu.sh [path/to/caelusOS.iso]"
    exit 1
fi

echo "[CAELUS-INFO] Launching CaelusOS ISO in QEMU Virtual Machine..."
qemu-system-x86_64 \
    -enable-kvm \
    -m 4096 \
    -smp 4 \
    -vga virtio \
    -display default,show-cursor=on \
    -cdrom "$ISO_PATH" \
    -boot d
