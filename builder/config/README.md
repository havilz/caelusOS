# builder/config

Direktori ini berisi berkas-berkas parameter penentuan sistem pembuatan ISO menggunakan kerangka kerja Debian live-build.

## Daftar Berkas & Sub-Direktori

* auto/config : Skrip inisialisasi live-build (arsitektur amd64, distribusi Debian Bookworm, kompresi squashfs, bootloader grub-efi).
* bootstrap : Konfigurasi URL server mirror Debian resmi (deb.debian.org).
* hooks/ : Direktori skrip pasca-ekstraksi (chroot hooks) yang dieksekusi secara sekuensial saat pembentukan ISO.

## Instruksi Modifikasi

Perubahan parameter seperti suite Debian atau tipe kompresi ISO diatur melalui auto/config.
