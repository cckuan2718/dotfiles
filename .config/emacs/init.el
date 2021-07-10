;;;; Package manager & wrapper

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-verbose t
      use-package-always-ensure t)

;;;; File cleanup

;;; Backup files
(setq backup-directory-alist `(("." . ,(expand-file-name "backup" user-emacs-directory)))
      backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;;; Custom settings
(setq custom-file (expand-file-name "custom_settings.el" user-emacs-directory))

;;;; Default coding system

(set-default-coding-systems 'utf-8)

;;;; Key bindings

(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))

;;;; Personal information

(setq user-full-name "Chang, Chu-Kuan"
      user-mail-address "cckuan@changchukuan.name")

;;;; General configuration

;;; User interface
(setq inhibit-splash-screen t
      initial-scratch-message nil
      echo-keystrokes 0.1
      visible-bell nil)

(scroll-bar-mode 0)
(tool-bar-mode 0)
(tooltip-mode 0)
(menu-bar-mode 0)
(mouse-avoidance-mode 'banish)

(show-paren-mode 1)
(global-display-line-numbers-mode 1)

(setq-default fill-column 80)
(global-display-fill-column-indicator-mode 1)

(defalias 'yes-or-no-p 'y-or-n-p)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Frame
(defun my/frame-setup (frame)
  (set-frame-font "Iosevka-16" t t)
  (set-fontset-font t 'han "Noto Sans CJK TC"))
(add-to-list 'after-make-frame-functions #'my/frame-setup)

;;; Mode line
(column-number-mode 1)
(use-package diminish)

;; "M-x all-the-icons-install-fonts" to install fonts to ~/.local/share/fonts/
(use-package all-the-icons)

(use-package doom-modeline
  :after doom-themes
  :init
  (setq doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-major-mode-color-icon t
	doom-modeline-buffer-state-icon t
	doom-modeline-buffer-modification-icon t
        doom-modeline-buffer-file-name-style 'truncate-upto-project
	doom-modeline-minor-modes t
	doom-modeline-indent-info t
	doom-modeline-buffer-encoding t)
  :config
  (doom-modeline-mode 1))

;;; Color theme
(use-package doom-themes
  :init
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  :config
  (load-theme 'doom-gruvbox t)
  (doom-themes-org-config))

;;; Highlight indentation
(global-whitespace-mode)
(setq whitespace-style '(face tabs tab-mark trailing))
(setq whitespace-display-mappings '((space-mark 32 [183] [46])
				    (tab-mark 9 [124 9] [92 9])))

;;;; Editing configuration

;;; tab is 8 char wide
(setq-default tab-width 8)

;; make tab key do indent first then completion.
(setq-default tab-always-indent 'complete)

;;; Making electric-indent behave sanely
(setq-default electric-indent-inhibit t)

;;; Backspacing the whole tab
(setq backward-delete-char-untabify-method 'hungry)

;;; Marking text
(delete-selection-mode t)
(setq select-enable-clipboard t)

;;; Insert matching parenthesis automatically
(electric-pair-mode 1)

;;; sentence ends with one space
(setq sentence-end-double-space nil)

;;; CamelCase as distinct words
(global-subword-mode)

;;; Command operate on whole line if no region found
(use-package whole-line-or-region
  :config
  (whole-line-or-region-global-mode))

;;; which-key
(use-package which-key
  :init
  (setq which-key-idle-delay 0.3)
  :config
  (which-key-mode))

;;;; Completion system

(use-package ivy
  :diminish ivy-mode
  :defer 0.1
  :init
  (setq ivy-use-virtual-buffers t
        ivy-count-format "(%d/%d) "
        ivy-height 6
	ivy-on-del-error-function nil)
  :bind (("C-c C-r" . ivy-resume)
         ("C-x B" . ivy-switch-buffer-other-window))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :after counsel
  :config
  (ivy-rich-mode 1))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper)))

(use-package counsel
  :after ivy
  :config
  (counsel-mode 1))

;;; Hippie expand
(global-set-key [remap dabbrev-expand] 'hippie-expand)

;;;; Navigation
(use-package avy
  :bind ("C-'" . avy-goto-char)
  :init
  (setq avy-keys '(?a ?o ?e ?u ?i ?d ?h ?t ?n ?s)))

;;;; Windows

(winner-mode 1)
(global-set-key (kbd "M-o") 'other-window) ; M-o to switch window

;;;; Modes

(defun my/disable-tabs ()
  (setq indent-tabs-mode nil))
(defun my/enable-tabs  (width)
  (setq indent-tabs-mode t)
  (setq tab-width width))

;;; Text mode and Auto Fill mode
(setq-default major-mode 'text-mode)
(add-hook 'text-mode-hook #'turn-on-auto-fill)

;;; org mode
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(setq org-directory "~/documents/org/")
(setq org-agenda-files `(,(expand-file-name "agendas" org-directory))
      org-default-notes-file (expand-file-name "notes.org" org-directory))

(defun my/org-mode-setup ()
  (org-indent-mode))
(add-hook 'org-mode-hook #'my/org-mode-setup)

;; Aesthetic settings
(setq org-ellipsis " ▾"
      org-hide-block-startup nil
      org-startup-folded 'content)

;;; sh-mode
(setq sh-basic-offset 8
      sh-indentation 8
      sh-indent-for-case-label 0
      sh-indent-for-case-alt '+)

;;; mail-mode
(setq auto-mode-alist (append '(("/tmp/mutt.*" . mail-mode) ("/tmp/neomutt.*" . mail-mode)) auto-mode-alist))
(defun my/mail-mode-setup ()
  (setq fill-column 72)
  (auto-fill-mode 1))
(add-hook 'mail-mode-hook #'my/mail-mode-setup)

;;; disable line numbers in specific mode
(dolist (mode '(term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;;; lua mode
(use-package lua-mode
  :hook (lua-mode . my/disable-tabs)
  :init
  (setq lua-indent-level 3))
