;
; mg config
;

;;; General settings
audible-bell -1
visible-bell -1
backup-to-home-directory 1
leave-tmpdir-backups 1
line-number-mode 1
column-number-mode 1
set-fill-column 72

;;; Modes
set-default-mode indent
auto-execute *.c c-mode
auto-execute /tmp/*mutt-* auto-fill-mode 1

;;; Key bindings
global-set-key "g" goto-line

