#!/bin/bash
set -e

TOOLBOX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$TOOLBOX_DIR/lib/colors.sh"
source "$TOOLBOX_DIR/lib/utils.sh"

log_info "Starting Rust Environment Installation..."
check_internet || exit 1

sudo apt update
sudo apt install -y rustc cargo

log_success "Rust Environment (rustc, cargo) installed successfully!"
log_info "Verifying Rust version..."
rustc --version
