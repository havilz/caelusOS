#!/bin/bash
set -e

TOOLBOX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$TOOLBOX_DIR/lib/colors.sh"
source "$TOOLBOX_DIR/lib/utils.sh"

log_info "Starting Mobile & Cross Platform Toolchain Installation..."
check_internet || exit 1

sudo apt update
sudo apt install -y android-tools-adb android-tools-fastboot

log_success "Android Command-line Tools (adb, fastboot) installed successfully!"
