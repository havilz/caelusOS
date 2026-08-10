# packages/caelus-settings

Direktori ini berisi seluruh berkas konfigurasi default sistem yang menimpa (overlay) konfigurasi standar Debian untuk memberikan pengalaman CaelusOS.

## Daftar Berkas & Sub-Direktori

* etc/os-release : Berkas identitas resmi OS (Name=CaelusOS, ID=caelus).
* etc/issue & etc/issue.net : Banner teks terminal tty CaelusOS.
* etc/lsb-release : Informasi kompatibilitas LSB.
* etc/default/grub : Konfigurasi bootloader GRUB (tema visual & parameter boot).
* etc/dconf/db/local.d/00-caelus : Overrides pengaturan dconf/GSettings desktop global.
* etc/skel/.config/picom/picom.conf : Konfigurasi Picom compositor dengan efek kawase blur dan glassmorphism.
* etc/skel/.config/alacritty/alacritty.toml : Tema warna terminal Alacritty (Deep Space Dark & Electric Cyan).
* etc/skel/.config/fastfetch/config.jsonc : Konfigurasi Fastfetch logo sistem CaelusOS.
* etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml : Konfigurasi tema XFCE Window Manager (Caelus-Dark).
* usr/share/glib-2.0/schemas/90_caelus.gschema.override : Berkas gschema override tema visual GTK gelap.

## Instruksi Modifikasi

Seluruh berkas di direktori ini akan disalin ke rootfs ISO saat proses build. Dilarang menyertakan path statis ke direktori home pengguna.
