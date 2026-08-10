#!/bin/bash
set -e

TOOLBOX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$TOOLBOX_DIR/lib/colors.sh"
source "$TOOLBOX_DIR/lib/utils.sh"

log_info "Starting Python Environment Installation..."
check_internet || exit 1

sudo apt update
sudo apt install -y python3 python3-pip python3-venv python3-full

log_success "Python Environment (Python3, PIP, Virtualenv) installed successfully!"
log_info "Verifying Python version..."
python3 --version
