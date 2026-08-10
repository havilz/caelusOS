#!/bin/bash
set -e

TOOLBOX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$TOOLBOX_DIR/lib/colors.sh"
source "$TOOLBOX_DIR/lib/utils.sh"

log_info "Starting Rust Toolchain (Rustup, Cargo, Rust-Analyzer) Installation..."
check_internet || exit 1

sudo apt update
sudo apt install -y build-essential curl gcc

if ! command -v rustup >/dev/null 2>&1; then
    log_info "Installing Rust via official Rustup installer..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env" || true
else
    log_info "Updating Rust via Rustup..."
    rustup update || true
fi

log_success "Rust Environment (rustc, cargo, rustup) installed successfully!"
log_info "Verifying Rust version..."
rustc --version
