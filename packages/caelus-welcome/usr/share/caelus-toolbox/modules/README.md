# packages/caelus-welcome/usr/share/caelus-toolbox/modules

Direktori ini berisi skrip-skrip modul mandiri yang mengontrol proses otomatisasi pengunduhan dan konfigurasi SDK/compiler pemrograman serta wizard pembuatan projek untuk caelus-toolbox.

## Daftar Berkas & Sub-Direktori

* 01-cpp.sh : Skrip auto-installer C/C++ Toolchain (GCC, G++, Clang, Make, CMake, GDB).
* 02-go.sh : Skrip auto-installer Go Development Kit & Air live reload engine.
* 03-rust.sh : Skrip auto-installer Rust Environment (Rustup, Cargo, Rust-Analyzer).
* 04-java.sh : Skrip auto-installer Java Ecosystem (OpenJDK 17/21, Maven, Gradle).
* 05-nodejs.sh : Skrip auto-installer Node.js LTS, NPM, PNPM, Bun, dan Next.js CLI.
* 06-python.sh : Skrip auto-installer Python3, PIP, Virtualenv, dan Poetry.
* 07-php.sh : Skrip auto-installer PHP 8.3, Composer, Nginx, dan MariaDB.
* 08-flutter.sh : Skrip auto-installer Flutter SDK dan Android Command-line Tools.
* 99-project-creator.sh : Skrip Project Creation Wizard (Scaffold projek baru atau clone repo dengan dukungan direktori titik . dan pengecekan otomatis dependensi SDK).

## Instruksi Modifikasi

Setiap modul wajib berformat sekuensial: Cek Koneksi -> Cek Existing -> Download & Install -> Export PATH -> Verifikasi.
