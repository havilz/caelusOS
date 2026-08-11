# Changelog CaelusOS

Dokumen ini mencatat seluruh riwayat perubahan, pembuatan modul, penambahan fitur, dan perbaikan pada projek **CaelusOS**.

Format pencatatan mengacu pada standar *Keep a Changelog*.

---

## [Unreleased] - Ignored `.github/` Directory & Cloud Shell Storage Diagnosis

### Changed
- **CI/CD `.github/` Folder Ignored (`.gitignore`)**:
  - Menambahkan direktori `.github/` ke dalam berkas `.gitignore` sesuai instruksi pengguna.

---

## [Native Debian Package Standardization for Docker & VS Code]

### Fixed
- Mengubah `seeds/apps.seed` untuk menggunakan paket resmi Debian `docker.io`, `docker-compose`, dan `containerd`.
- Penginstalan VS Code dipindahkan ke hook `05-install-third-party-binaries.chroot`.

---

## [1.0.0-rc1] - 2026-08-10 - Full Distribution Codebase Complete

### Added
- Seluruh 7 Milestone pembangunan distribusi CaelusOS telah selesai 100% dan terverifikasi.
