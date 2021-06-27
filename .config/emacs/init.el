;;;; Package manager

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-verbose t
      use-package-always-ensure t)

;;;; Personal information

(setq user-full-name "Chang, Chu-Kuan"
      user-mail-address "cckuan@changchukuan.name")

;;;; User interface

(setq inhibit-splash-screen t
      initial-scratch-message nil)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(show-paren-mode 1)
(global-display-line-numbers-mode 1)

(add-to-list 'default-frame-alist
             '(font . "Iosevka-16"))

(defalias 'yes-or-no-p 'y-or-n-p)

(setq echo-keystrokes 0.1
      visible-bell nil)

;;; Mode line
(column-number-mode 1)

;;; Color theme
(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox t))

;;;; Editing

;;; Marking text
(delete-selection-mode t)
(setq select-enable-clipboard t)

;;; Insert matching parenthesis automatically
(electric-pair-mode 1)

;;; Kill/paste on whole line when no region is specified
(use-package whole-line-or-region
  :config
  (whole-line-or-region-global-mode 1))

;;; CamelCase as distinct words
(global-subword-mode)

;;;; File cleanup

;;; Backup files
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))
      backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;;; Custom settings
(setq custom-file (concat user-emacs-directory "custom-settings.el"))

;;;; Key bindings

(global-set-key (kbd "M-[") 'tab-bar-history-back)
(global-set-key (kbd "M-]") 'tab-bar-history-forward)
(global-set-key (kbd "M-i") 'imenu)
(define-key key-translation-map [?\C-x] [?\C-z])
(define-key key-translation-map [?\C-z] [?\C-x])
(define-key key-translation-map [?\M-x] [?\M-z])
(define-key key-translation-map [?\M-z] [?\M-x])

;;;; Completion

;;; icomplete
(icomplete-mode 1)
(setq icomplete-separator "\n"
      icomplete-hide-common-prefix nil
      icomplete-in-buffer t)

;;; Replace DAbbrev with Hippie expand
(global-set-key [remap dabbrev-expand] 'hippie-expand)

;;;; Windows

(winner-mode 1)
(global-set-key (kbd "M-o") 'other-window) ; M-o to switch window

;;;; Misc

(setq sentence-end-double-space nil) ; sentence ends with one space
(setq apropos-sort-by-scores      t) ; sort apropos by relevancy

;;;; Modes

;;; Text mode and Auto Fill mode
(setq-default major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
