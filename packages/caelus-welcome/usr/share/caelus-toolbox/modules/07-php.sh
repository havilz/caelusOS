#!/bin/bash
set -e

TOOLBOX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$TOOLBOX_DIR/lib/colors.sh"
source "$TOOLBOX_DIR/lib/utils.sh"

log_info "Starting PHP & Web Server Installation..."
check_internet || exit 1

sudo apt update
sudo apt install -y php-cli php-curl php-mbstring php-xml composer nginx mariadb-server

log_success "PHP & Web Server (PHP, Composer, Nginx, MariaDB) installed successfully!"
log_info "Verifying PHP version..."
php -v
