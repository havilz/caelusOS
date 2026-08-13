#!/bin/bash
set -e

TOOLBOX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$TOOLBOX_DIR/lib/colors.sh"
source "$TOOLBOX_DIR/lib/utils.sh"

log_info "Starting Flutter SDK & Mobile Toolchain Installation..."
check_internet || exit 1

sudo apt update
sudo apt install -y android-tools-adb android-tools-fastboot git curl unzip xz-utils libglu1-mesa

FLUTTER_INSTALL_DIR="/opt/flutter"

if [ ! -d "$FLUTTER_INSTALL_DIR" ]; then
    log_info "Cloning Flutter SDK stable branch to $FLUTTER_INSTALL_DIR..."
    sudo git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_INSTALL_DIR"
    sudo chown -R "$USER:$USER" "$FLUTTER_INSTALL_DIR"
else
    log_info "Flutter SDK already exists at $FLUTTER_INSTALL_DIR. Updating..."
    git -C "$FLUTTER_INSTALL_DIR" pull || true
fi

# Add Flutter to system PATH
if [ ! -f /etc/profile.d/flutter.sh ]; then
    echo 'export PATH="$PATH:/opt/flutter/bin"' | sudo tee /etc/profile.d/flutter.sh >/dev/null
    sudo chmod +x /etc/profile.d/flutter.sh
fi

export PATH="$PATH:/opt/flutter/bin"

log_success "Flutter SDK & Android Command-line Tools installed successfully!"
log_info "Verifying Flutter version..."
flutter --version || true
