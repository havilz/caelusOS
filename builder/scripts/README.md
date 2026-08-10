# builder/scripts

Direktori ini berisi skrip-skrip utilitas otomatisasi untuk kompilasi, pembersihan, dan pengujian ISO CaelusOS.

## Daftar Berkas & Sub-Direktori

* build-iso.sh : Skrip utama pencetak ISO CaelusOS (menggabungkan seeds, packages, dan installer).
* clean-build.sh : Skrip pembersih cache build temporary dan lingkungan chroot.
* test-qemu.sh : Skrip runner untuk menguji boot file ISO hasil kompilasi menggunakan emulator QEMU.

## Instruksi Modifikasi

Seluruh skrip di direktori ini wajib memiliki izin eksekusi (+x) dan mendeklarasikan fail-fast mode set -e.
