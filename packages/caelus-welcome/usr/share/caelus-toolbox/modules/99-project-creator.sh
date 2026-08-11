#!/bin/bash
set -e

TOOLBOX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$TOOLBOX_DIR/lib/colors.sh"
source "$TOOLBOX_DIR/lib/utils.sh"

CURRENT_DIR="$(pwd)"

show_project_creator_menu() {
    print_header
    echo -e "${CLR_PURPLE}${CLR_BOLD}--- PROJECT CREATION WIZARD ---${CLR_RESET}"
    echo -e "${CLR_WHITE}Target Directory: ${CLR_CYAN}$CURRENT_DIR${CLR_RESET}"
    echo ""
    echo -e "${CLR_WHITE}[1] Mobile Development (Flutter / React Native)${CLR_RESET}"
    echo -e "${CLR_WHITE}[2] Web Development (Next.js / Node.js / PHP / Go)${CLR_RESET}"
    echo -e "${CLR_WHITE}[3] System & Desktop Development (C++ / Rust / Java)${CLR_RESET}"
    echo -e "${CLR_MUTED}--------------------------------------------------------------------${CLR_RESET}"
    echo -e "${CLR_WHITE}[0] Back to Main Menu${CLR_RESET}"
    echo -e "${CLR_MUTED}--------------------------------------------------------------------${CLR_RESET}"
    echo -n "Select project domain [0-3]: "
}

handle_scaffold() {
    local stack_type="$1"
    local proj_name="$2"

    case "$stack_type" in
        "flutter")
            if [ "$proj_name" = "." ]; then
                flutter create .
            else
                flutter create "$proj_name"
            fi
            ;;
        "react-native")
            if [ "$proj_name" = "." ]; then
                npx react-native@latest init "CaelusApp" --directory .
            else
                npx react-native@latest init "$proj_name"
            fi
            ;;
        "nextjs")
            if [ "$proj_name" = "." ]; then
                npx create-next-app@latest .
            else
                npx create-next-app@latest "$proj_name"
            fi
            ;;
        "nodejs")
            if [ "$proj_name" = "." ]; then
                npm init -y
            else
                mkdir -p "$proj_name" && cd "$proj_name" && npm init -y
            fi
            ;;
        "gomod")
            if [ "$proj_name" = "." ]; then
                local mod_name=$(basename "$CURRENT_DIR")
                go mod init "$mod_name"
            else
                mkdir -p "$proj_name" && cd "$proj_name" && go mod init "$proj_name"
            fi
            ;;
        "rust")
            if [ "$proj_name" = "." ]; then
                cargo init .
            else
                cargo new "$proj_name"
            fi
            ;;
        "cpp")
            if [ "$proj_name" = "." ]; then
                cmake -B build .
            else
                mkdir -p "$proj_name" && cd "$proj_name" && cmake -B build .
            fi
            ;;
    esac
}

handle_project_mode() {
    local stack_name="$1"
    local dep_cmd="$2"
    local dep_module="$3"
    local stack_type="$4"

    # Source profile scripts to ensure PATH is updated within the same session
    if [ -f /etc/profile.d/flutter.sh ]; then
        source /etc/profile.d/flutter.sh 2>/dev/null || true
    fi
    if [ -d "/opt/flutter/bin" ]; then
        export PATH="$PATH:/opt/flutter/bin"
    fi

    log_info "Checking dependencies for $stack_name..."
    if ! command -v "$dep_cmd" >/dev/null 2>&1; then
        log_warn "Dependency '$dep_cmd' for $stack_name is not installed."
        echo -n "Would you like to install it now via Caelus Developer Toolbox? (y/n): "
        read -r install_ans
        if [[ "$install_ans" =~ ^[Yy]$ ]]; then
            bash "$TOOLBOX_DIR/modules/$dep_module"
        else
            log_error "Cannot proceed without $dep_cmd."
            return 1
        fi
    fi

    log_success "Dependency '$dep_cmd' is ready."
    echo ""
    echo -e "${CLR_CYAN}Select Project Creation Method:${CLR_RESET}"
    echo "[1] Clone Remote Repository (Git Clone + Auto Restore)"
    echo "[2] Create Brand New Project"
    echo -n "Select option [1-2]: "
    read -r method_ans

    if [ "$method_ans" = "1" ]; then
        echo -n "Enter Git Repository URL: "
        read -r repo_url
        if [ -n "$repo_url" ]; then
            log_info "Cloning repository $repo_url..."
            git clone "$repo_url"
            log_success "Repository cloned successfully!"
        fi
    elif [ "$method_ans" = "2" ]; then
        echo -n "Enter Project Name (Type '.' to use current folder '$CURRENT_DIR'): "
        read -r proj_name
        if [ -z "$proj_name" ]; then
            log_error "Project name cannot be empty."
            return 1
        fi

        log_info "Scaffolding new $stack_name project '$proj_name'..."
        handle_scaffold "$stack_type" "$proj_name"
        log_success "Project $proj_name created successfully!"
    fi
}

main_project_creator() {
    show_project_creator_menu
    read -r choice
    case "$choice" in
        1)
            echo ""
            echo "[1] Flutter App"
            echo "[2] React Native App"
            echo -n "Select stack [1-2]: "
            read -r stack_choice
            if [ "$stack_choice" = "1" ]; then
                handle_project_mode "Flutter" "flutter" "08-flutter.sh" "flutter"
            elif [ "$stack_choice" = "2" ]; then
                handle_project_mode "React Native" "npm" "05-nodejs.sh" "react-native"
            fi
            ;;
        2)
            echo ""
            echo "[1] Next.js App"
            echo "[2] Node.js Project"
            echo "[3] Go Web Module"
            echo -n "Select stack [1-3]: "
            read -r stack_choice
            if [ "$stack_choice" = "1" ]; then
                handle_project_mode "Next.js" "npm" "05-nodejs.sh" "nextjs"
            elif [ "$stack_choice" = "2" ]; then
                handle_project_mode "Node.js" "npm" "05-nodejs.sh" "nodejs"
            elif [ "$stack_choice" = "3" ]; then
                handle_project_mode "Go Module" "go" "02-go.sh" "gomod"
            fi
            ;;
        3)
            echo ""
            echo "[1] Rust Project"
            echo "[2] C++ CMake Project"
            echo -n "Select stack [1-2]: "
            read -r stack_choice
            if [ "$stack_choice" = "1" ]; then
                handle_project_mode "Rust" "cargo" "03-rust.sh" "rust"
            elif [ "$stack_choice" = "2" ]; then
                handle_project_mode "C++" "cmake" "01-cpp.sh" "cpp"
            fi
            ;;
        0) return 0 ;;
        *) log_warn "Invalid selection." ;;
    esac
}

main_project_creator
