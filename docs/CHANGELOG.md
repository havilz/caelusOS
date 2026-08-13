# Changelog CaelusOS

Dokumen ini mencatat seluruh riwayat perubahan, pembuatan modul, penambahan fitur, dan perbaikan pada projek **CaelusOS**.

Format pencatatan mengacu pada standar *Keep a Changelog*.

---

## [Unreleased] - WSL NTFS Mount Point Device Node Resolution

### Fixed
- **WSL NTFS Mount Detection & Temporary Workspace (`builder/scripts/build-iso.sh`)**:
  - **Akar Masalah**: Pada WSL, partisi Windows NTFS (`/mnt/c/` atau `/mnt/d/`) di-mount dengan flag keamanan Linux `nodev` dan `noexec`. Ketika `debootstrap` mencoba membuat berkas perangkat Linux (seperti `mknod /dev/null`), WSL memblokir eksekusi dengan pesan error: `E: Cannot install into target ... mounted with noexec or nodev`.
  - **Solusi Tuntas**: `build-iso.sh` diperbarui untuk secara otomatis mendeteksi ketika skrip dijalankan di dalam lingkungan mount WSL (`/mnt/*`). Skrip akan menyalin ruang kerja perakitan ke direktori Linux native `/tmp/caelus-builder` (ext4) untuk menjalankan `debootstrap` dan `live-build` dengan 100% hak akses `mknod`, kemudian memindahkan ISO yang berhasil dirakit kembali ke `C:\project\caelusOS\builder\out\caelusOS-live-amd64.iso` di Windows.

---

## [Live-Build Storage Optimization]

### Fixed
- Menambahkan `--cache false` dan `--cache-packages false` pada `builder/auto/config`.

---

## [1.0.0-rc1] - 2026-08-10 - Full Distribution Codebase Complete

### Added
- Seluruh 7 Milestone pembangunan distribusi CaelusOS telah selesai 100% dan terverifikasi.
