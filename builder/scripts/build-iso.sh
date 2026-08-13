#!/bin/bash
set -e

log_info()    { echo -e "\e[34m[CAELUS-INFO]\e[0m $1"; }
log_success() { echo -e "\e[32m[CAELUS-SUCCESS]\e[0m $1"; }
log_error()   { echo -e "\e[31m[CAELUS-ERROR]\e[0m $1"; }

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BUILDER_DIR="$PROJECT_ROOT/builder"
OUT_DIR="$BUILDER_DIR/out"

# ─────────────────────────────────────────────────────────────────────────────
# WSL MOUNT POINT DETECTION
# If running from a Windows NTFS mount (/mnt/c or /mnt/d), mirror the project
# to a native Linux ext4 path (/tmp/caelus-project) so live-build can use
# mknod, device nodes, and full kernel syscalls without NTFS restrictions.
#
# CACHE PRESERVATION STRATEGY (to prevent re-downloads):
#   - The WORK_PROJECT directory at /tmp/caelus-project is NEVER deleted.
#   - Only project config/script/seed/package files are synced from Windows.
#   - Build state dirs (chroot/, .build/, cache/, binary/) are NEVER touched.
# ─────────────────────────────────────────────────────────────────────────────
if [[ "$PROJECT_ROOT" == /mnt/* ]] && [[ "$PWD" != /tmp/* ]]; then
    log_info "WSL mount point detected. Syncing source files to /tmp/caelus-project..."
    WORK_PROJECT="/tmp/caelus-project"
    mkdir -p "$WORK_PROJECT"

    # Sync ONLY source directories (never touch build state directories)
    # IMPORTANT: scripts/ always force-copied so latest edits from Windows always apply
    for dir in seeds packages builder/auto builder/config docs; do
        if [ -d "$PROJECT_ROOT/$dir" ]; then
            mkdir -p "$WORK_PROJECT/$dir"
            cp -ru "$PROJECT_ROOT/$dir/." "$WORK_PROJECT/$dir/" 2>/dev/null || true
        fi
    done
    # Always force-sync scripts so the latest version is guaranteed to run
    if [ -d "$PROJECT_ROOT/builder/scripts" ]; then
        mkdir -p "$WORK_PROJECT/builder/scripts"
        cp -rf "$PROJECT_ROOT/builder/scripts/"* "$WORK_PROJECT/builder/scripts/" 2>/dev/null || true
    fi
    # Sync root-level files
    cp -u "$PROJECT_ROOT/.gitignore" "$WORK_PROJECT/" 2>/dev/null || true

    log_info "Sync complete. Running build from /tmp/caelus-project..."
    cd "$WORK_PROJECT/builder/scripts"
    bash ./build-iso.sh

    # Copy generated ISO back to Windows folder
    ISO_FOUND=$(find "$WORK_PROJECT/builder/out" -maxdepth 1 -name "*.iso" 2>/dev/null | head -n1)
    if [ -n "$ISO_FOUND" ] && [ -f "$ISO_FOUND" ]; then
        mkdir -p "$OUT_DIR"
        cp "$ISO_FOUND" "$OUT_DIR/caelusOS-live-amd64.iso"
        cp "${ISO_FOUND%.iso}.iso.sha256" "$OUT_DIR/caelusOS-live-amd64.iso.sha256" 2>/dev/null || true
        log_success "ISO copied to Windows: $OUT_DIR/caelusOS-live-amd64.iso"
    fi
    exit 0
fi

# ─────────────────────────────────────────────────────────────────────────────
# FROM HERE: Running inside /tmp/caelus-project (native Linux ext4)
# ─────────────────────────────────────────────────────────────────────────────

log_info "Starting CaelusOS Live ISO Build Pipeline..."

# Sync system clock to avoid apt "Release file not valid yet" errors (WSL 2 drift)
log_info "Syncing system clock..."
if command -v hwclock &>/dev/null; then
    hwclock --hctosys 2>/dev/null || true
fi
GOOGLE_DATE=$(curl -s --head https://google.com 2>/dev/null | grep -i "^date:" | sed 's/[Dd]ate: //g' | tr -d '\r')
if [ -n "$GOOGLE_DATE" ]; then
    date -s "$GOOGLE_DATE" > /dev/null 2>&1 && log_info "Clock synced: $(date)" || true
fi

mkdir -p "$OUT_DIR"
cd "$BUILDER_DIR"

# Ensure PATH includes /sbin and /usr/sbin first for dpkg and live-build sub-shells
export PATH="/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin:$PATH"
[ -f /usr/bin/isohybrid ] && [ ! -f /bin/isohybrid ] && ln -sf /usr/bin/isohybrid /bin/isohybrid 2>/dev/null || true
[ -f /usr/bin/isohybrid ] && [ ! -f /sbin/isohybrid ] && ln -sf /usr/bin/isohybrid /sbin/isohybrid 2>/dev/null || true



log_info "1. Wiring seeds/*.seed into package-lists/caelus.list.chroot..."
if [ -d "$BUILDER_DIR/config/auto" ]; then
    rm -rf "$BUILDER_DIR/config/auto"
fi

mkdir -p "$BUILDER_DIR/config/package-lists"
LIST_FILE="$BUILDER_DIR/config/package-lists/caelus.list.chroot"
> "$LIST_FILE"

for seed in "$PROJECT_ROOT/seeds/core.seed" "$PROJECT_ROOT/seeds/desktop.seed" "$PROJECT_ROOT/seeds/apps.seed" "$PROJECT_ROOT/seeds/drivers.seed"; do
    if [ -f "$seed" ]; then
        grep -v '^\s*#' "$seed" | grep -v '^\s*$' >> "$LIST_FILE.raw" || true
    fi
done

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
cp -r "$PROJECT_ROOT/packages/caelus-artwork/"*   "$BUILDER_DIR/config/includes.chroot/" 2>/dev/null || true
cp -r "$PROJECT_ROOT/packages/caelus-plymouth/"*  "$BUILDER_DIR/config/includes.chroot/" 2>/dev/null || true
cp -r "$PROJECT_ROOT/packages/caelus-welcome/"*   "$BUILDER_DIR/config/includes.chroot/" 2>/dev/null || true

log_info "3. Configuring Live-Build..."
chmod +x "$BUILDER_DIR/config/hooks/live/"*.chroot 2>/dev/null || true
if [ -f "$BUILDER_DIR/auto/config" ]; then
    chmod +x "$BUILDER_DIR/auto/config"
    ./auto/config --cache true --cache-packages true --memtest none
else
    lb config --cache true --cache-packages true --memtest none
fi

# ─────────────────────────────────────────────────────────────────────────────
# SMART STAGE RESUMPTION
# Check live-build stage files to determine which stages are already complete.
# This prevents re-downloading 1 GB of packages when retrying after a failure.
#   .build/bootstrap  → lb bootstrap already done
#   .build/chroot     → lb chroot (package install) already done
# ─────────────────────────────────────────────────────────────────────────────
BOOTSTRAP_DONE=false
CHROOT_DONE=false
[ -f "$BUILDER_DIR/.build/bootstrap" ] && BOOTSTRAP_DONE=true
[ -f "$BUILDER_DIR/.build/chroot" ]    && CHROOT_DONE=true

# Pre-download any small live-build internal packages using WSL host DNS
# (chroot DNS is unreliable in WSL 2 - this bypasses it entirely)
log_info "Pre-fetching live-build internal packages into chroot apt cache..."
mkdir -p chroot/var/cache/apt/archives
cd /tmp
for pkg in dctrl-tools syslinux-common isolinux librsvg2-bin; do
    if ! ls "$BUILDER_DIR/chroot/var/cache/apt/archives/${pkg}_"*.deb &>/dev/null 2>&1; then
        apt-get download $pkg 2>/dev/null && mv ${pkg}_*.deb "$BUILDER_DIR/chroot/var/cache/apt/archives/" 2>/dev/null || true
    fi
done
# Fix chroot dpkg environment: Ensure start-stop-daemon is executable and PATH is valid inside chroot
if [ -d "$BUILDER_DIR/chroot" ]; then
    mkdir -p "$BUILDER_DIR/chroot/sbin" "$BUILDER_DIR/chroot/usr/sbin"
    if [ -f "$BUILDER_DIR/chroot/sbin/start-stop-daemon.distrib" ]; then
        cp -f "$BUILDER_DIR/chroot/sbin/start-stop-daemon.distrib" "$BUILDER_DIR/chroot/sbin/start-stop-daemon"
    elif [ ! -f "$BUILDER_DIR/chroot/sbin/start-stop-daemon" ]; then
        cat > "$BUILDER_DIR/chroot/sbin/start-stop-daemon" << 'SSD_EOF'
#!/bin/sh
exit 0
SSD_EOF
    fi
    cp -f "$BUILDER_DIR/chroot/sbin/start-stop-daemon" "$BUILDER_DIR/chroot/usr/sbin/start-stop-daemon" 2>/dev/null || true
    chmod +x "$BUILDER_DIR/chroot/sbin/start-stop-daemon"* 2>/dev/null || true
    chmod +x "$BUILDER_DIR/chroot/usr/sbin/start-stop-daemon"* 2>/dev/null || true
    echo 'PATH="/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin"' > "$BUILDER_DIR/chroot/etc/environment"

    # Fix Debian Bookworm isolinux/syslinux path reorganization
    mkdir -p "$BUILDER_DIR/chroot/usr/lib/syslinux" "$BUILDER_DIR/chroot/root/isolinux"
    find "$BUILDER_DIR/chroot/usr/lib" -name "isolinux.bin" -exec cp -f {} "$BUILDER_DIR/chroot/usr/lib/syslinux/" \; 2>/dev/null || true
    find "$BUILDER_DIR/chroot/usr/lib" -name "isolinux.bin" -exec cp -f {} "$BUILDER_DIR/chroot/root/isolinux/" \; 2>/dev/null || true
    find "$BUILDER_DIR/chroot/usr/lib" -name "vesamenu.c32" -exec cp -f {} "$BUILDER_DIR/chroot/usr/lib/syslinux/" \; 2>/dev/null || true
    find "$BUILDER_DIR/chroot/usr/lib" -name "vesamenu.c32" -exec cp -f {} "$BUILDER_DIR/chroot/root/isolinux/" \; 2>/dev/null || true
    find "$BUILDER_DIR/chroot/usr/lib" -name "*.c32" -exec cp -f {} "$BUILDER_DIR/chroot/usr/lib/syslinux/" \; 2>/dev/null || true
    find "$BUILDER_DIR/chroot/usr/lib" -name "*.c32" -exec cp -f {} "$BUILDER_DIR/chroot/root/isolinux/" \; 2>/dev/null || true
fi

cd "$BUILDER_DIR"
log_success "Pre-fetch complete."

# Ensure isolinux & librsvg2-bin packages are installed on host WSL
if ! command -v rsvg-convert &>/dev/null || ! [ -f /usr/lib/ISOLINUX/isolinux.bin ]; then
    log_info "Installing librsvg2-bin, isolinux & syslinux-common on host WSL..."
    apt-get update && apt-get install -y librsvg2-bin isolinux syslinux-common 2>/dev/null || true
fi

# Create rsvg wrapper script to fix multi-SVG CLI argument error and prevent stdin hangs
cat > /usr/bin/rsvg << 'RSVG_EOF'
#!/bin/bash
args=()
svg_found=false
for arg in "$@"; do
    if [[ "$arg" == *.svg ]]; then
        if [ "$svg_found" = false ] && [ -f "$arg" ]; then
            args+=("$arg")
            svg_found=true
        fi
    else
        args+=("$arg")
    fi
done

if [ "$svg_found" = true ]; then
    exec /usr/bin/rsvg-convert "${args[@]}" < /dev/null
else
    exit 0
fi
RSVG_EOF
chmod +x /usr/bin/rsvg 2>/dev/null || true
cp -f /usr/bin/rsvg /bin/rsvg 2>/dev/null || true
if [ -d "$BUILDER_DIR/chroot" ]; then
    mkdir -p "$BUILDER_DIR/chroot/usr/bin" "$BUILDER_DIR/chroot/bin"
    cp -f /usr/bin/rsvg "$BUILDER_DIR/chroot/usr/bin/rsvg" 2>/dev/null || true
    cp -f /usr/bin/rsvg "$BUILDER_DIR/chroot/bin/rsvg" 2>/dev/null || true
fi

# Populate all isolinux/syslinux paths inside chroot so live-build binary stage never fails
mkdir -p "$BUILDER_DIR/chroot/usr/lib/syslinux" \
         "$BUILDER_DIR/chroot/usr/lib/ISOLINUX" \
         "$BUILDER_DIR/chroot/root/isolinux" \
         "$BUILDER_DIR/chroot/usr/share/syslinux"

for src in /usr/lib/ISOLINUX/isolinux.bin /usr/share/live/build/bootloaders/isolinux/isolinux.bin /usr/lib/syslinux/isolinux.bin; do
    if [ -f "$src" ]; then
        cp -f "$src" "$BUILDER_DIR/chroot/usr/lib/syslinux/" 2>/dev/null || true
        cp -f "$src" "$BUILDER_DIR/chroot/usr/lib/ISOLINUX/" 2>/dev/null || true
        cp -f "$src" "$BUILDER_DIR/chroot/root/isolinux/" 2>/dev/null || true
        cp -f "$src" "$BUILDER_DIR/chroot/usr/share/syslinux/" 2>/dev/null || true
        break
    fi
done

for src in /usr/lib/syslinux/modules/bios /usr/lib/syslinux /usr/share/syslinux; do
    if [ -d "$src" ]; then
        cp -f "$src"/*.c32 "$BUILDER_DIR/chroot/usr/lib/syslinux/" 2>/dev/null || true
        cp -f "$src"/*.c32 "$BUILDER_DIR/chroot/root/isolinux/" 2>/dev/null || true
        cp -f "$src"/*.c32 "$BUILDER_DIR/chroot/usr/share/syslinux/" 2>/dev/null || true
    fi
done
# Always inject apt no-languages & no-cache config to prevent Translation-en Hash Sum mismatch
if [ -d "$BUILDER_DIR/chroot" ]; then
    mkdir -p "$BUILDER_DIR/chroot/etc/apt/apt.conf.d"
    cat > "$BUILDER_DIR/chroot/etc/apt/apt.conf.d/99no-valid-until" << 'EOF'
Acquire::Check-Valid-Until "false";
Acquire::ForceIPv4 "true";
Acquire::Languages "none";
Acquire::http::No-Cache "true";
EOF
    echo "nameserver 8.8.8.8" > "$BUILDER_DIR/chroot/etc/resolv.conf"

    # Ensure kernel (vmlinuz) and initrd are copied into binary/live/ for syslinux bootloader
    mkdir -p "$BUILDER_DIR/binary/live"
    if [ -d "$BUILDER_DIR/chroot/boot" ]; then
        cp -f "$BUILDER_DIR/chroot/boot/vmlinuz"* "$BUILDER_DIR/binary/live/" 2>/dev/null || true
        cp -f "$BUILDER_DIR/chroot/boot/initrd"* "$BUILDER_DIR/binary/live/" 2>/dev/null || true
    fi

    # Clean stale bootloader target directories to prevent "mv: Directory not empty" errors
    rm -rf "$BUILDER_DIR/binary/isolinux" \
           "$BUILDER_DIR/binary/isolinux.tmp" \
           "$BUILDER_DIR/binary/boot/isolinux" \
           "$BUILDER_DIR/chroot/root/isolinux.tmp" 2>/dev/null || true
fi

if [ "$CHROOT_DONE" = true ]; then
    log_info "Stage CHROOT already complete. Skipping bootstrap & package install."
    log_info "Running lb binary only..."
elif [ "$BOOTSTRAP_DONE" = true ]; then
    log_info "Stage BOOTSTRAP already complete. Skipping debootstrap."
    log_info "Injecting apt config & DNS into chroot..."
    mkdir -p chroot/etc/apt/apt.conf.d
    cat > chroot/etc/apt/apt.conf.d/99no-valid-until << 'EOF'
Acquire::Check-Valid-Until "false";
Acquire::ForceIPv4 "true";
Acquire::Languages "none";
Acquire::http::No-Cache "true";
EOF
    echo "nameserver 8.8.8.8" > chroot/etc/resolv.conf
    log_success "apt config & DNS injected."
    log_info "Running lb chroot..."
    lb chroot
    log_info "Running lb binary..."
else
    log_info "3a. Running lb bootstrap (debootstrap)..."
    lb bootstrap

    log_info "3b. Injecting apt config & DNS into freshly bootstrapped chroot..."
    mkdir -p chroot/etc/apt/apt.conf.d
    cat > chroot/etc/apt/apt.conf.d/99no-valid-until << 'EOF'
Acquire::Check-Valid-Until "false";
Acquire::ForceIPv4 "true";
EOF
    echo "nameserver 8.8.8.8" > chroot/etc/resolv.conf
    log_success "apt config & DNS injected."

    log_info "3c. Running lb chroot (installs all packages)..."
    lb chroot

    log_info "3d. Running lb binary..."
fi

lb binary

ISO_FOUND=$(find "$BUILDER_DIR" -maxdepth 1 -name "*.iso" | head -n1)

if [ -n "$ISO_FOUND" ] && [ -f "$ISO_FOUND" ]; then
    mv "$ISO_FOUND" "$OUT_DIR/caelusOS-live-amd64.iso"
    cd "$OUT_DIR"
    sha256sum caelusOS-live-amd64.iso > caelusOS-live-amd64.iso.sha256
    log_success "CaelusOS ISO generated successfully: $OUT_DIR/caelusOS-live-amd64.iso"
else
    log_error "ISO generation failed. No ISO file found in $BUILDER_DIR"
    exit 1
fi
