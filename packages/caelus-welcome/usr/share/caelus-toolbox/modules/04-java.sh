#!/bin/bash
set -e

TOOLBOX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$TOOLBOX_DIR/lib/colors.sh"
source "$TOOLBOX_DIR/lib/utils.sh"

log_info "Starting Java Ecosystem Installation..."
check_internet || exit 1

sudo apt update
sudo apt install -y default-jdk maven gradle

log_success "Java Ecosystem (OpenJDK, Maven, Gradle) installed successfully!"
log_info "Verifying Java version..."
java -version
