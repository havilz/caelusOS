# builder/config/hooks

Direktori ini berisi skrip pasca-ekstraksi (post-install chroot hooks) yang dieksekusi secara sekuensial di dalam lingkungan chroot saat proses pembuatan ISO CaelusOS.

## Daftar Berkas & Sub-Direktori

* live/01-update-dconf.chroot : Skrip pengompilasi skema GSettings dan database dconf.
* live/02-update-icon-cache.chroot : Skrip pembaru cache ikon Caelus-Circle dan desktop database.
* live/03-enable-services.chroot : Skrip pengaktif layanan systemd (LightDM, NetworkManager, PipeWire).

## Instruksi Modifikasi

Seluruh skrip di direktori ini wajib mengikuti konvensi penamaan sekuensial NN-deskripsi.chroot dan diawali dengan set -e.
