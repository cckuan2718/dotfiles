# Manually installed program

In OpenBSD:

*   Programs are installed at '/usr/local/bin'.
*   Man pages are installed at '/usr/local/man'.
*   Configure make(1) accordingly.

# Suckless utilities

*   Modify config.mk to cope with OpenBSD file hierarchy.
*   If there is any OpenBSD modification in config.mk, uncomment them.

## dwm

*   No patch applied

## dmenu

*   No patch applied

## st
*   st(1) crashes when using less(1) command, USE more(1) INSTEAD.
*   Patched with scrollback, gruvbox theme, anysize

