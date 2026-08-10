# builder

Direktori ini berisi seluruh perkakas (toolchain), aturan live-build, skrip pasca-ekstraksi chroot hooks, serta skrip otomatisasi pembuat file ISO CaelusOS.

## Daftar Berkas & Sub-Direktori

* config/ : Direktori aturan konfigurasi live-build, URL mirror Debian, dan skrip chroot hooks.
* overlay/ : Direktori penggabungan aset dan konfigurasi dari direktori packages/ ke lingkungan rootfs.
* scripts/ : Direktori skrip utilitas pembuat ISO (build-iso.sh), pembersih (clean-build.sh), dan penguji QEMU (test-qemu.sh).
* Dockerfile : Berkas definisi containerized build environment untuk kompilasi ISO di Windows WSL2 / Docker Host.

## Instruksi Modifikasi

Kompilasi ISO native wajib dijalankan dengan hak akses root/sudo melalui skrip scripts/build-iso.sh.
