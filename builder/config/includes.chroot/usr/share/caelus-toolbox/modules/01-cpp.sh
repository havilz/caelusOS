#!/bin/bash
set -e

TOOLBOX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$TOOLBOX_DIR/lib/colors.sh"
source "$TOOLBOX_DIR/lib/utils.sh"

log_info "Starting C / C++ Toolchain Installation..."
check_internet || exit 1

sudo apt update
sudo apt install -y build-essential gcc g++ clang make cmake gdb gdbserver ninja-build

log_success "C / C++ Toolchain (GCC, G++, Clang, Make, CMake, GDB) installed successfully!"
