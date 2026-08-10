#!/bin/bash
set -e

TOOLBOX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$TOOLBOX_DIR/lib/colors.sh"
source "$TOOLBOX_DIR/lib/utils.sh"

show_menu() {
    print_header

    # Dynamically query package statuses
    local status_node=$(get_package_status "node")
    local status_php=$(get_package_status "php")
    local status_go=$(get_package_status "go")
    local status_python=$(get_package_status "python3")
    local status_flutter=$(get_package_status "flutter")
    local status_gcc=$(get_package_status "gcc")
    local status_rust=$(get_package_status "rustc")
    local status_java=$(get_package_status "java")

    echo -e "${CLR_PURPLE}${CLR_BOLD}--- WEB DEVELOPMENT ------------------------------------------------${CLR_RESET}"
    echo -e "${CLR_WHITE}[1] Node.js & Web Stack (Node, NPM, Bun, Next.js)  ${status_node}${CLR_RESET}"
    echo -e "${CLR_WHITE}[2] PHP & Web Server (PHP 8.3, Composer, Nginx)     ${status_php}${CLR_RESET}"
    echo -e "${CLR_WHITE}[3] Go Development Kit (Golang & Air)               ${status_go}${CLR_RESET}"
    echo -e "${CLR_WHITE}[4] Python Environment (Python3, PIP, Poetry)       ${status_python}${CLR_RESET}"
    echo ""

    echo -e "${CLR_PURPLE}${CLR_BOLD}--- MOBILE DEVELOPMENT ---------------------------------------------${CLR_RESET}"
    echo -e "${CLR_WHITE}[5] Flutter SDK & Mobile Tools                      ${status_flutter}${CLR_RESET}"
    echo ""

    echo -e "${CLR_PURPLE}${CLR_BOLD}--- SYSTEM & DESKTOP -----------------------------------------------${CLR_RESET}"
    echo -e "${CLR_WHITE}[6] C / C++ Toolchain (GCC, G++, CMake, GDB)        ${status_gcc}${CLR_RESET}"
    echo -e "${CLR_WHITE}[7] Rust Environment (Rustup, Cargo)               ${status_rust}${CLR_RESET}"
    echo -e "${CLR_WHITE}[8] Java Ecosystem (OpenJDK, Maven, Gradle)         ${status_java}${CLR_RESET}"
    echo ""

    echo -e "${CLR_PURPLE}${CLR_BOLD}--- DATABASES & SERVICES -------------------------------------------${CLR_RESET}"
    echo -e "${CLR_WHITE}[9] Manage Local Database Services (Postgres, Redis)${CLR_RESET}"
    echo -e "${CLR_MUTED}--------------------------------------------------------------------${CLR_RESET}"
    echo -e "${CLR_CYAN}${CLR_BOLD}[99] Project Creation Wizard (Scaffold / Clone Projects)${CLR_RESET}"
    echo -e "${CLR_WHITE}[0] Exit Toolbox${CLR_RESET}"
    echo -e "${CLR_MUTED}--------------------------------------------------------------------${CLR_RESET}"
    echo -n "Select option [0-99]: "
}

main() {
    while true; do
        show_menu
        read -r choice
        case "$choice" in
            1) bash "$TOOLBOX_DIR/modules/05-nodejs.sh" ;;
            2) bash "$TOOLBOX_DIR/modules/07-php.sh" ;;
            3) bash "$TOOLBOX_DIR/modules/02-go.sh" ;;
            4) bash "$TOOLBOX_DIR/modules/06-python.sh" ;;
            5) bash "$TOOLBOX_DIR/modules/08-flutter.sh" ;;
            6) bash "$TOOLBOX_DIR/modules/01-cpp.sh" ;;
            7) bash "$TOOLBOX_DIR/modules/03-rust.sh" ;;
            8) bash "$TOOLBOX_DIR/modules/04-java.sh" ;;
            9) log_info "Local database services (PostgreSQL & Redis) are active." ;;
            99) bash "$TOOLBOX_DIR/modules/99-project-creator.sh" ;;
            0) log_info "Exiting Caelus Developer Toolbox. Happy Coding!"; exit 0 ;;
            *) log_warn "Invalid selection. Please enter 0-99." ;;
        esac
        echo ""
        echo -n "Press Enter to return to main menu..."
        read -r
    done
}

main "$@"
