# packages/caelus-welcome/usr/share/caelus-toolbox

Direktori ini berisi engine utama dan library pendukung untuk Caelus Developer Toolbox (caelus-toolbox), sebuah CLI TUI interaktif ala GhostSpectre untuk memasang SDK dan compiler pemrograman.

## Daftar Berkas & Sub-Direktori

* main.sh : Skrip utama penampil menu TUI interaktif terminal.
* lib/ : Direktori library fungsi helper dan token warna ANSI terminal.
* modules/ : Direktori skrip modul auto-installer compiler dan SDK pemrograman.

## Instruksi Modifikasi

Skrip di direktori ini wajib menggunakan POSIX shell / Bash standar dan menyertakan pembacaan token warna ANSI dari lib/colors.sh.
