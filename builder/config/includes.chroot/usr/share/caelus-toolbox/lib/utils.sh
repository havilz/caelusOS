#!/bin/bash

# Load colors if available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/colors.sh" ]; then
    source "$SCRIPT_DIR/colors.sh"
fi

log_info() {
    echo -e "${CLR_CYAN}[INFO]${CLR_RESET} $1"
}

log_success() {
    echo -e "${CLR_GREEN}[SUCCESS]${CLR_RESET} $1"
}

log_warn() {
    echo -e "${CLR_YELLOW}[WARN]${CLR_RESET} $1"
}

log_error() {
    echo -e "${CLR_RED}[ERROR]${CLR_RESET} $1"
}

check_internet() {
    log_info "Checking internet connectivity..."
    if ping -c 1 1.1.1.1 >/dev/null 2>&1 || ping -n 1 1.1.1.1 >/dev/null 2>&1 || curl -s --connect-timeout 3 http://1.1.1.1 >/dev/null 2>&1 || wget -q --spider --timeout=3 http://1.1.1.1 >/dev/null 2>&1; then
        log_success "Internet connection verified."
        return 0
    else
        log_error "No active internet connection detected. Please check network settings."
        return 1
    fi
}

# Function to check binary status and return colored status tag
# Usage: get_package_status "command" ["expected_major_version"]
get_package_status() {
    local cmd="$1"
    local expected_ver="$2"

    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo -e "${CLR_RED}[Not Installed]${CLR_RESET}"
        return
    fi

    # Detect installed version
    local raw_ver=""
    raw_ver=$("$cmd" --version 2>/dev/null | head -n1 | grep -oP '\d+\.\d+(\.\d+)?' | head -n1) || true
    if [ -z "$raw_ver" ]; then
        raw_ver=$("$cmd" -version 2>/dev/null | head -n1 | grep -oP '\d+\.\d+(\.\d+)?' | head -n1) || true
    fi
    if [ -z "$raw_ver" ]; then
        raw_ver=$("$cmd" -V 2>/dev/null | head -n1 | grep -oP '\d+\.\d+(\.\d+)?' | head -n1) || true
    fi

    # If we couldn't detect version, just show Installed
    if [ -z "$raw_ver" ]; then
        echo -e "${CLR_GREEN}[Installed]${CLR_RESET}"
        return
    fi

    # If no expected version specified, just show detected version in green
    if [ -z "$expected_ver" ]; then
        echo -e "${CLR_GREEN}[v${raw_ver}]${CLR_RESET}"
        return
    fi

    # Compare major version against expected
    local installed_major="${raw_ver%%.*}"
    local expected_major="${expected_ver%%.*}"

    if [[ "$raw_ver" == "$expected_ver"* ]] || [[ "$installed_major" == "$expected_major" ]]; then
        echo -e "${CLR_GREEN}[v${raw_ver}]${CLR_RESET}"
    else
        echo -e "${CLR_YELLOW}[v${raw_ver} - ${expected_ver} recommended]${CLR_RESET}"
    fi
}

print_header() {
    clear
    echo -e "${CLR_CYAN}${CLR_BOLD}"
    echo " ===================================================================="
    echo "   ______   ___   ______  ___     __  ______  ____  ____  __     ______  "
    echo "  / ____/  /   | / ____/ / /_  __/ / / / __ \/ __ \/ __ \/ /    / ____/  "
    echo " / /      / /| |/ __/   / / / / / / / / / / / / / / / / / /    /___ \    "
    echo " / /___   / ___ / /___  / / /_/ / /_/ / /_/ / /_/ / /_/ / /___ ____/ /    "
    echo " \____/  /_/  /________/_/\__,_/\____/\____/\____/\____/_____/______/     "
    echo "                                                                         "
    echo "                    CAELUS DEVELOPER TOOLBOX v2.0                        "
    echo " ====================================================================${CLR_RESET}"
    echo ""
}
