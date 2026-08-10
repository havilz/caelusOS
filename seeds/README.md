# seeds

Direktori ini berisi berkas manifestasi paket perangkat lunak (Ubuntu-Style Package Seeds) yang menentukan seluruh aplikasi, kernel, driver, dan komponen desktop yang akan diunduh dari repositori Debian saat proses pembuatan ISO CaelusOS.

## Daftar Berkas & Sub-Direktori

* core.seed : Berkas daftar paket dasar sistem tanpa GUI (Linux Kernel, systemd, APT, driver microcode).
* desktop.seed : Berkas daftar paket lingkungan desktop & audio stack (LightDM, XFCE4, Picom compositor, PipeWire audio).
* apps.seed : Berkas daftar paket aplikasi pengembang & alat kerja (VS Code, Antigravity AI, Docker Engine, Podman, LazyDocker, Postman, PostgreSQL, SQLite, Redis, Firefox ESR, MPV, Ristretto, Wine, Git).
* drivers.seed : Berkas daftar driver non-free (firmware GPU Nvidia/AMD & WiFi Intel/Realtek).
* blacklist.seed : Berkas daftar paket bloatware yang dilarang diinstal ke dalam ISO.

## Instruksi Modifikasi

Untuk menambahkan paket baru ke CaelusOS, buka berkas .seed yang sesuai dengan kategorinya dan tambahkan nama paket Debian resmi di baris baru.
