# builder/overlay

Direktori ini berfungsi sebagai tempat penampung temporary untuk proses penggabungan (overlay) seluruh aset dan berkas konfigurasi dari direktori packages/ ke dalam sistem berkas utama rootfs ISO.

## Daftar Berkas & Sub-Direktori

* includes.chroot/ : Direktori penampung hasil salinan berkas dari packages/caelus-settings/, packages/caelus-artwork/, packages/caelus-plymouth/, dan packages/caelus-welcome/.

## Instruksi Modifikasi

Isi dari direktori ini akan disalin secara otomatis oleh skrip build-iso.sh sebelum menjalankan proses live-build.
