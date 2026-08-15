#!/bin/bash
set -e

BUILDER_DIR="/tmp/caelus-project/builder"

cleanup() {
    echo "[INFO] Cleaning up mounts..."
    umount -l "$BUILDER_DIR/chroot/dev/pts" 2>/dev/null || true
    umount -l "$BUILDER_DIR/chroot/dev" 2>/dev/null || true
    umount -l "$BUILDER_DIR/chroot/sys" 2>/dev/null || true
    umount -l "$BUILDER_DIR/chroot/proc" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

echo "[INFO] Setting up pseudo-filesystems in chroot..."
mkdir -p "$BUILDER_DIR/chroot/proc" \
         "$BUILDER_DIR/chroot/sys" \
         "$BUILDER_DIR/chroot/dev" \
         "$BUILDER_DIR/chroot/dev/pts" \
         "$BUILDER_DIR/chroot/etc/apt/apt.conf.d" \
         "$BUILDER_DIR/chroot/usr/sbin" \
         "$BUILDER_DIR/chroot/sbin"

# Copy start-stop-daemon if missing
if [ ! -f "$BUILDER_DIR/chroot/usr/sbin/start-stop-daemon" ]; then
    cp -f /usr/sbin/start-stop-daemon "$BUILDER_DIR/chroot/usr/sbin/" 2>/dev/null || true
    cp -f /usr/sbin/start-stop-daemon "$BUILDER_DIR/chroot/sbin/" 2>/dev/null || true
    chmod +x "$BUILDER_DIR/chroot/usr/sbin/start-stop-daemon" "$BUILDER_DIR/chroot/sbin/start-stop-daemon" 2>/dev/null || true
fi

mount -t proc proc "$BUILDER_DIR/chroot/proc" 2>/dev/null || true
mount -t sysfs sys "$BUILDER_DIR/chroot/sys" 2>/dev/null || true
mount --bind /dev "$BUILDER_DIR/chroot/dev" 2>/dev/null || true
mount --bind /dev/pts "$BUILDER_DIR/chroot/dev/pts" 2>/dev/null || true

echo 'Acquire::Check-Valid-Until "false";' > "$BUILDER_DIR/chroot/etc/apt/apt.conf.d/99no-check-valid-until"
echo 'Acquire::Max-FutureTime "86400";' >> "$BUILDER_DIR/chroot/etc/apt/apt.conf.d/99no-check-valid-until"
echo "nameserver 8.8.8.8" > "$BUILDER_DIR/chroot/etc/resolv.conf"

echo "[INFO] Updating chroot apt cache..."
chroot "$BUILDER_DIR/chroot" /usr/bin/env -i \
    PATH='/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin' \
    DEBIAN_FRONTEND=noninteractive \
    apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::Max-FutureTime=86400

echo "[INFO] Installing live-boot and live-config packages..."
chroot "$BUILDER_DIR/chroot" /usr/bin/env -i \
    PATH='/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin' \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    -o Acquire::Check-Valid-Until=false -o Acquire::Max-FutureTime=86400 \
    live-boot live-boot-initramfs-tools live-config live-config-systemd user-setup

# Configure fast, deadlock-free gzip compression for initramfs
mkdir -p "$BUILDER_DIR/chroot/etc/initramfs-tools/conf.d"
echo "COMPRESS=gzip" > "$BUILDER_DIR/chroot/etc/initramfs-tools/conf.d/compress.conf"
sed -i 's/^COMPRESS=.*/COMPRESS=gzip/' "$BUILDER_DIR/chroot/etc/initramfs-tools/initramfs.conf" 2>/dev/null || true

echo "[INFO] Regenerating initramfs with live-boot hooks (verbose mode)..."
chroot "$BUILDER_DIR/chroot" /usr/bin/env -i \
    PATH='/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin' \
    update-initramfs -v -u -k all < /dev/null

echo "[INFO] Staging kernel and initramfs to binary/live/..."
mkdir -p "$BUILDER_DIR/binary/live"
cp -f "$BUILDER_DIR/chroot/boot/vmlinuz"* "$BUILDER_DIR/binary/live/vmlinuz" 2>/dev/null || true
cp -f "$BUILDER_DIR/chroot/boot/initrd"* "$BUILDER_DIR/binary/live/initrd.img" 2>/dev/null || true

# Invalidate previous squashfs and stage markers
rm -f "$BUILDER_DIR/binary/live/filesystem.squashfs" \
      "$BUILDER_DIR/.build/binary_rootfs" \
      "$BUILDER_DIR/.build/binary_iso" 2>/dev/null || true

echo "[SUCCESS] Live-boot integration completed successfully."
