#!/bin/bash
set -e

TOOLBOX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$TOOLBOX_DIR/lib/colors.sh"
source "$TOOLBOX_DIR/lib/utils.sh"

log_info "Starting Go Development Kit Installation..."
check_internet || exit 1

sudo apt update
sudo apt install -y golang-go

log_success "Go Development Kit installed successfully!"
log_info "Verifying Go version..."
go version
