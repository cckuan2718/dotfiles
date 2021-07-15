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

(use-package auto-package-update
  :init
  (setq auto-package-update-interval 7
        auto-package-update-prompt-before-update t
        auto-package-update-hide-results nil
        auto-package-update-delete-old-versions t)
  :config
  (auto-package-update-maybe))

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
(blink-cursor-mode 0)
(mouse-avoidance-mode 'banish)

(show-paren-mode 1)
(add-hook 'prog-mode-hook (lambda () (display-line-numbers-mode 1)))

(setq-default fill-column 80)
(global-display-fill-column-indicator-mode 1)

(defalias 'yes-or-no-p 'y-or-n-p)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Font
(defun my/frame-setup (frame)
  (set-frame-font "Iosevka-16" t t)
  (set-fontset-font t 'han "Noto Sans CJK TC"))
(add-to-list 'after-make-frame-functions #'my/frame-setup)
(my/frame-setup 0)

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
(diminish 'global-whitespace-mode)
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
(diminish 'subword-mode)

;;; Command operate on whole line if no region found
(use-package whole-line-or-region
  :diminish whole-line-or-region-local-mode
  :config
  (whole-line-or-region-global-mode))

;;; which-key
(use-package which-key
  :diminish which-key-mode
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
  :diminish counsel-mode
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

;;;; Authentication
(require 'auth-source-pass)
(auth-source-pass-enable)

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

;;; lisp mode
(add-hook 'emacs-lisp-mode-hook #'my/disable-tabs)

;;; dired
(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(setq dired-listing-switches "-aFhl"
      delete-by-moving-to-trash t)

(global-set-key (kbd "C-x j") 'dired-jump)

;;; projectile
(use-package projectile
  :diminish projectile-mode
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/.local/src/")
    (setq projectile-project-search-path '("~/.local/src/")))
  (setq projectile-switch-project-action #'projectile-dired
        projectile-completion-system 'ivy)
  :config (projectile-mode 1))

;;; magit
(use-package magit)

;;; CC mode
(setq-default c-basic-offset 8)
(setq c-default-style "k&r")

;;; mu4e
(use-package mu4e
  :defer 10
  :ensure nil
  :bind (:map mu4e-headers-mode-map
         ("C-=" . mu4e-headers-split-view-grow)
         :map mu4e-view-mode-map
         ("C-=" . mu4e-headers-split-view-grow))
  :config
  ;; maildir
  (setq mu4e-update-interval nil
        ;; mu4e-update-interval (* 10 60)
        mu4e-get-mail-command "mbsync --all"
        ;; mu4e-get-mail-command "true"
        mu4e-maildir "~/.local/share/mail")

  ;; Make sure that moving a message (like to Trash) causes the
  ;; message to get a new file name.  This helps to avoid the
  ;; dreaded "UID is N beyond highest assigned" error.
  ;; See `man mbsync'
  (setq mu4e-change-filenames-when-moving t)

  ;; context
  (setq mu4e-contexts
        `( ,(make-mu4e-context
             :name "cckname"
             :enter-func (lambda () (mu4e-message "Entering cckname context"))
             :leave-func (lambda () (mu4e-message "Leaving cckname context"))
             :match-func (lambda (msg)
                           (when msg
                             (string-match-p "^/cckname" (mu4e-message-field msg :maildir))))
             :vars '((user-mail-address  . "cckuan@changchukuan.name"  )
                     (user-full-name     . "Chang, Chu-Kuan" )
                     (mu4e-sent-folder   . "/cckname/Sent")
                     (mu4e-trash-folder  . "/cckname/Trash")
                     (mu4e-drafts-folder . "/cckname/Drafts")
                     (mu4e-refile-folder . "/cckname/Archive")
                     (mu4e-compose-signature . (concat
                                                "Chang, Chu-Kuan 張居寬\n"
                                                "0x3BFF0775354DC84B"
                                                ))
                     (smtpmail-smtp-server  . "mail.changchukuan.name")
                     (smtpmail-smtp-service . 465)
                     (smtpmail-stream-type  . ssl)
                     (smtpmail-smtp-user    . "cckuan")))))
  (setq mu4e-maildir-shortcuts
        '(("/cckname/Archive/2021" . ?a)
          ("/cckname/Drafts"       . ?d)
          ("/cckname/DMARC"        . ?D)
          ("/cckname/Finance"      . ?f)
          ("/cckname/Inbox"        . ?i)
          ("/cckname/Mlist"        . ?m)
          ("/cckname/Sent"         . ?s)
          ("/cckname/Sent"         . ?s)
          ("/cckname/Spam"         . ?S)
          ("/cckname/Trash"        . ?t)
          ("/cckname/Sysadmin"     . ?y)))
  (setq mu4e-context-policy 'pick-first
        mu4e-compose-context-policy 'always-ask)

  ;; viewer
  (setq mu4e-view-show-images t
        mu4e-view-show-addresses t)
  (when (fboundp 'imagemagick-register-types)
    (imagemagick-register-types))
  (setq mu4e-attachment-dir "~/downloads")

  ;; composer
  (setq mu4e-sent-messages-behavior 'sent
        message-kill-buffer-on-exit t
        mail-user-agent 'mu4e-user-agent
        message-send-mail-function 'smtpmail-send-it
        mml-secure-openpgp-signers '("3BFF0775354DC84B"))

  ;; user interface
  (setq mu4e-completing-read-function #'ivy-completing-read
        mu4e-headers-date-format "%Y-%m-%d"
        mu4e-headers-time-format "%H:%M")
  (mu4e t))

