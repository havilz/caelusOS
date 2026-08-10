# CaelusOS

CaelusOS adalah Sistem Operasi berbasis Linux Debian yang dirancang khusus sebagai The Ultimate Dedicated Developer Operating System.

## Positioning

| Distro Linux | Target Utama | Kondisi Bawaan (Out-of-the-box) |
| :--- | :--- | :--- |
| Ubuntu / Debian Standard | Daily Use, Desktop Umum, Server | Polos (Blank slate). Pengembang wajib menginstall compiler, IDE, database, dan container manual satu per satu. |
| Kali Linux | Cybersecurity, Pentesting, Digital Forensics | Terisi 600+ tools keamanan, sniffing, dan eksplorasi jaringan secara pre-installed. |
| CaelusOS | Dedicated Software Engineer & Developer Workstation | Terisi ekosistem pengembang modern (VS Code, Antigravity AI, Docker Engine, Podman, LazyDocker, Postman, DB Lokal, Firefox, MPV, Wine) + caelus-toolbox (GhostSpectre-style) untuk instalasi SDK 1-klik dari terminal. |

* Base Foundation: Debian GNU/Linux (Bookworm 12 / Trixie 13)
* Primary Architecture: amd64 (x86_64)
* Design Philosophy: Deep Space Dark aesthetics, glassmorphism accents, fast boot times, low memory footprint, and out-of-the-box developer toolchain.

## Source Tree

* seeds/ : Ubuntu-Style Package Manifests
* packages/ : Sistem Identitas, Tema, & Konfigurasi OS
* installer/ : Engine Installer GUI (Calamares)
* builder/ : Toolchain Pembuat File ISO (.iso)

## Fitur Utama

* Dedicated Developer Operating System: Dirancang dari awal khusus untuk kebutuhan perangkat lunak dan pengembangan sistem.
* Pre-Packed Development Tools: Langsung menyediakan alat kerja pengembang utama out-of-the-box.
* Caelus Developer Toolbox (caelus-toolbox): CLI TUI interaktif dari terminal ala GhostSpectre untuk mengunduh dan memasang compiler/SDK secara on-demand dalam 1-klik.
* Clean Base + High Performance: Konsumsi RAM ringan (XFCE + Picom compositor) dengan efek visual glassmorphism dan tema gelap Deep Space.
* Container & Database Ready: Integrasi langsung Docker Engine, Podman, LazyDocker, PostgreSQL, dan Redis tanpa perlunya setup awal yang rumit.
* Desktop Essentials & Windows Compatibility: Dilengkapi Mozilla Firefox ESR, pemutar media MPV, Ristretto image viewer, dan Wine untuk kompatibilitas aplikasi Windows.

## Paket Terinstal Out-Of-The-Box

### Editor Kode & Alat AI
* VS Code (Visual Studio Code Official)
* Antigravity (AI Agentic Assistant)

### Browser & Media
* Mozilla Firefox ESR (Web Browser Ringan & Cepat)
* MPV / Celluloid (Video & Audio Player)
* Ristretto / Feh (Image Viewer)

### Windows Compatibility Layer
* Wine & Wine64 (Compatibility layer aplikasi Windows .exe)

### Containerization & Orchestration
* Docker Engine & Docker CLI
* Docker Compose
* Podman
* LazyDocker

### API Testing
* Postman
* HTTPie CLI

### Database Lokal
* PostgreSQL
* SQLite 3
* Redis

### Versi Kontrol & Utility
* Git
* Curl & Wget

## Caelus Developer Toolbox (caelus-toolbox)

CaelusOS dilengkapi dengan perkakas CLI interaktif khas bernama caelus-toolbox yang dapat dipanggil langsung dari terminal via perintah caelus-toolbox atau alias dev.

Fungsi utama caelus-toolbox adalah menyediakan pemasangan SDK dan compiler pemrograman secara 1-klik on-demand tanpa perlu mengetikkan perintah apt atau mengkonfigurasi variabel PATH secara manual:

* [1] Install C / C++ Toolchain (GCC, G++, Clang, Make, CMake, GDB)
* [2] Install Go Development Kit (Golang & Air Live Reload)
* [3] Install Rust Environment (Rustup, Cargo, Rust-Analyzer)
* [4] Install Java Ecosystem (OpenJDK 17/21, Maven, Gradle)
* [5] Install Node.js & Web Stack (Node.js LTS, NPM, PNPM, Bun, Next.js)
* [6] Install Python Environment (Python3, PIP, Virtualenv, Poetry)
* [7] Install PHP & Web Server (PHP 8.3, Composer, Nginx, MariaDB)
* [8] Install Mobile & Cross Platform (Flutter SDK, Android Tools)
