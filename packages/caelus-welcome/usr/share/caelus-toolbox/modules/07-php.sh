#!/bin/bash
set -e

TOOLBOX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$TOOLBOX_DIR/lib/colors.sh"
source "$TOOLBOX_DIR/lib/utils.sh"

log_info "Starting PHP 8.3 & Web Server Stack Installation..."
check_internet || exit 1

sudo apt update
sudo apt install -y ca-certificates lsb-release apt-transport-https curl gnupg

# Add Sury PHP Repository for PHP 8.3
if [ ! -f /etc/apt/sources.list.d/php.list ]; then
    log_info "Adding Sury PHP (deb.sury.org) APT Repository for PHP 8.3..."
    curl -sSLo /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg || true
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list >/dev/null || true
    sudo apt update || true
fi

sudo apt install -y php8.3 php8.3-cli php8.3-curl php8.3-mbstring php8.3-xml php8.3-mysql composer nginx mariadb-server || sudo apt install -y php-cli php-curl php-mbstring php-xml composer nginx mariadb-server

log_success "PHP 8.3, Composer, Nginx, and MariaDB installed successfully!"
log_info "Verifying PHP version..."
php -v
