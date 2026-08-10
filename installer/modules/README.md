# installer/modules

Direktori ini berisi modul-modul aturan konfigurasi Calamares untuk mengontrol proses instalasi disk fisik.

## Daftar Berkas & Sub-Direktori

* welcome.conf : Modul pemeriksaan kebutuhan sistem (RAM, diskspace, koneksi daya).
* locale.conf : Modul pemilihan zona waktu, bahasa, dan format tanggal.
* partition.conf : Modul aturan partisi disk otomatis (ext4 / btrfs dengan enkripsi LUKS).
* users.conf : Modul pembuatan akun pengguna, hostname komputer, dan kata sandi root (auto-add to docker group).
* finished.conf : Modul tampilan konfirmasi selesai dan opsi reboot sistem.

## Instruksi Modifikasi

Setiap modul dihubungkan dalam urutan eksekusi yang ditentukan di installer/settings.conf.
