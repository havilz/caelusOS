#!/bin/bash
set -e

TOOLBOX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$TOOLBOX_DIR/lib/colors.sh"
source "$TOOLBOX_DIR/lib/utils.sh"

log_info "Starting Node.js LTS & Web Stack Installation..."
check_internet || exit 1

sudo apt update
sudo apt install -y curl ca-certificates gnupg

# Add NodeSource Node.js LTS repository
if [ ! -f /etc/apt/sources.list.d/nodesource.list ]; then
    log_info "Adding NodeSource Node.js LTS APT Repository..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
fi

sudo apt install -y nodejs

# Install global package managers (PNPM & Bun)
log_info "Installing PNPM & Bun package managers..."
sudo npm install -g pnpm bun || true

log_success "Node.js LTS, NPM, PNPM, and Bun installed successfully!"
log_info "Verifying Node.js version..."
node -v
npm -v
