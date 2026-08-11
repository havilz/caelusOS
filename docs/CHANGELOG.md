# Changelog CaelusOS

Dokumen ini mencatat seluruh riwayat perubahan, pembuatan modul, penambahan fitur, dan perbaikan pada projek **CaelusOS**.

Format pencatatan mengacu pada standar *Keep a Changelog*.

---

## [Unreleased] - Live-Build Storage Optimization

### Fixed
- **Disk Space Optimization (`builder/auto/config`)**:
  - Menambahkan flag `--cache false` dan `--cache-packages false` pada `builder/auto/config`.
  - **Penjelasan**: Secara bawaan, `live-build` menyimpan salinan ganda berkas `.deb` (~1.8 GB) di folder `cache/packages.chroot/` selain mengekstraknya di folder `chroot/`. Menonaktifkan cache berkas `.deb` menghemat ruang disk hingga ~2 GB, sehingga perakitan ISO tidak akan lagi mengalami error *No space left on device* pada lingkungan dengan kuota disk terbatas seperti Google Cloud Shell.

---

## [Ignored `.github/` Directory & Cloud Shell Storage Diagnosis]

### Changed
- Menambahkan direktori `.github/` ke `.gitignore`.

---

## [1.0.0-rc1] - 2026-08-10 - Full Distribution Codebase Complete

### Added
- Seluruh 7 Milestone pembangunan distribusi CaelusOS telah selesai 100% dan terverifikasi.
