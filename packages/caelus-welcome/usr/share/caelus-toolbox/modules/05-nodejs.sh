#!/bin/bash
set -e

TOOLBOX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$TOOLBOX_DIR/lib/colors.sh"
source "$TOOLBOX_DIR/lib/utils.sh"

log_info "Starting Node.js & Web Stack Installation..."
check_internet || exit 1

sudo apt update
sudo apt install -y nodejs npm

log_success "Node.js & NPM installed successfully!"
log_info "Verifying Node.js version..."
node -v
