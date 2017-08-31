;;; -*- lexical-binding: t -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Initialize package and use-package

(setf use-package-always-ensure t
      use-package-always-pin "melpa-stable"
      package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")
			 ("gnu" . "https://elpa.gnu.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")))
(eval-when-compile
  (package-initialize)
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
  (require 'use-package))
(require 'bind-key)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Color theme

(use-package color-theme-sanityinc-tomorrow
  :pin melpa
  :init
  (add-to-list 'custom-safe-themes
               "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a")
  :config
  (color-theme-sanityinc-tomorrow-night))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Window configuration

(use-package window-purpose
  :config
  (defun layout-dev ()
    (interactive)
    (unless purpose-mode
      (let ((try-force-window '(purpose-display-reuse-window-purpose
                                purpose-display-same-window)))
        (setf purpose-user-mode-purposes '((eshell-mode . terminal)
                                           (prog-mode . general)
                                           (text-mode . general)
                                           (dired-mode . general))
              purpose-user-regexp-purposes '(("^\\*eshell" . terminal))
              purpose-special-action-sequences `((terminal ,@try-force-window))))
      (purpose-compile-user-configuration)
      (purpose-mode))
    (purpose-load-window-layout "dev")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ErgoEmacs - Meta-based keybindings

(use-package ergoemacs-mode :demand
  :pin melpa
  :config
  (setf ergoemacs-keyboard-layout "dv"
        ergoemacs-theme nil
        icicle-ido-like-mode nil)
  (ergoemacs-mode 1)
  ;; Symbol's function definition is void: ergoemacs-org-mode-paste
  (fset 'ergoemacs-org-mode-paste 'ergoemacs-paste)
  :bind (("M-v" . ergoemacs-beginning-or-end-of-buffer)
         ("M-w" . switch-to-buffer)
         ("M-m" . back-to-indentation)
         ("M-3" . delete-other-windows)
         ("M-0" . delete-window)
         ("S-<tab>" . tab-to-tab-stop)
         ("<backtab>" . tab-to-tab-stop)
         ("C-M-S-b" . compile)
         ("C-B" . recompile)
         ("S-<space>" . self-insert-command)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Completion helpers

(use-package smex
  :config
  (smex-initialize))

(use-package ido-vertical-mode :demand
  :config
  (ido-mode 1)
  (ido-everywhere 1)
  (ido-vertical-mode 1)
  :bind (:map ido-common-completion-map
         ("M-t" . ido-next-match)
         ("M-c" . ido-prev-match)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; General programming helpers

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package highlight-symbol
  :config
  (setf highlight-symbol-idle-delay 0)
  (add-hook 'prog-mode-hook 'highlight-symbol-mode)
  :bind (("M-s" . highlight-symbol-at-point)
         ("M-S" . highlight-symbol-remove-all)))

(use-package multiple-cursors
  :bind (("M->" . mc/mark-next-like-this)
         ("M-<" . mc/mark-previous-like-this)
         ("C-M-<" . mc/mark-all-like-this)
         ("C-M-," . mc/mark-all-dwim)))

(use-package editorconfig
  :config
  (editorconfig-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Language modes

(use-package tex :ensure auctex
  :bind (:map LaTeX-mode-map
         ("M-<return>" . LaTeX-insert-item)))

(use-package fsharp-mode
  :pin melpa
  :config
  (defun my-fsharp-mode-hook ()
    (electric-indent-local-mode 0))
  (add-hook 'fsharp-mode-hook 'my-fsharp-mode-hook)
  (setf fsharp-indent-offset 4
        inferior-fsharp-program
        (case system-type
          ("windows-nt"
           "\"c:/Program Files (x86)/Microsoft SDKs/F#/4.0/Framework/v4.0/fsi.exe\"")
          (t "fsharpi")))
  :bind (:map fsharp-mode-map
         ("M-<return>" . fsharp-eval-region)
         ("C-M-x" . fsharp-eval-phrase)
         ("C-<tab>" . fsharp-ac/complete-at-point)))

(use-package haskell-mode
  :config
  (setf haskell-program-name "ghci")
  (defun my-haskell-mode-hook ()
    (turn-on-haskell-indent))
  (add-hook 'haskell-mode 'my-haskell-mode-hook)
  :bind (:map haskell-mode-map
         ("C-c C-r" . inferior-haskell-reload-file)))

(use-package idris-mode)

(use-package tuareg)

(use-package markdown-mode
  :config
  (defun text-mode-init ()
    (toggle-word-wrap 1))
  (add-hook 'text-mode-hook 'text-mode-init)
  :bind (:map markdown-mode-map
         ("M-n" . forward-char)
         ("M-p" . kill-word)))

(use-package groovy-mode
  :config
  (setf (alist-get "Jenkinsfile$" auto-mode-alist) 'groovy-mode))

(use-package powershell)

(use-package sass-mode
  :mode "\\.sass\\'"
  :config
  (setf (alist-get "\\.scss$" auto-mode-alist) 'scss-mode))

(use-package emmet-mode
  :config
  (add-hook 'sgml-mode-hook 'emmet-mode)
  (add-hook 'css-mode-hook 'emmet-mode)
  (add-hook 'sass-mode-hook 'emmet-mode))

(use-package yaml-mode)

(use-package toml-mode
  :pin melpa)

(use-package rust-mode
  :pin melpa)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Other modes

(use-package restclient
  :pin melpa
  :config
  (defun url-cookie-expired-p (cookie)
    "Return non-nil if COOKIE is expired."
    (let ((exp (url-cookie-expires cookie)))
      (and (> (length exp) 0)
           (condition-case ()
               (> (float-time) (float-time (date-to-time exp)))
             (error "")))))
  (defun restclient-window ()
    (interactive)
    (let* ((main-buffer (switch-to-buffer-other-frame "*REST client*"))
           (main-window (get-buffer-window main-buffer t))
           (frame (window-frame main-window))
           (result-buffer (get-buffer-create "*HTTP Response*"))
           (result-window (split-window-below)))
      (set-window-buffer result-window result-buffer)
      (with-current-buffer main-buffer
        (restclient-mode)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Version control helpers

(use-package magit
  :bind (("C-x g" . magit-status)
         :map magit-mode-map
         ("M-w" . switch-to-buffer)))

(use-package git-gutter-fringe
  :config
  (add-hook 'prog-mode-hook 'git-gutter))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Windows-specific settings

(setenv "PATH" (concat "C:\\Program Files\\git\\usr\\bin;" (getenv "PATH")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Misc settings

(fset 'yes-or-no-p 'y-or-n-p)

;; Fix msft regexp for fsc and wsfsc output
(setf (alist-get 'msft compilation-error-regexp-alist-alist)
        '("^ *\\(?:[0-9]+>\\)?\\(\\(?:[a-zA-Z]:\\)?[^:(	\n]+\\)(\\([0-9]+\\)\\(?:,\\([0-9]+\\)\\(?:,[0-9]+,[0-9]+\\)?\\)?) ?:\\( \\(?:[a-z]+ \\)?warning\\(?: [A-Z0-9]+:\\)\\)?" 1 2 3 (4))
      compilation-error-regexp-alist
        (cons 'msft compilation-error-regexp-alist))

;; XML mode for *.*proj and other .NET XML files
(setf (alist-get "\\.[^.]*proj$" auto-mode-alist) 'nxml-mode)
(setf (alist-get "\\.targets$" auto-mode-alist) 'nxml-mode)
(setf (alist-get "\\.config$" auto-mode-alist) 'nxml-mode)

(prefer-coding-system 'utf-8)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-by-copying t)
 '(backup-directory-alist (quote (("." . "~/.saves"))))
 '(column-number-mode t)
 '(compilation-scroll-output (quote first-error))
 '(custom-enabled-themes (quote (sanityinc-tomorrow-night)))
 '(delete-old-versions t)
 '(electric-pair-mode t)
 '(fill-column 79)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(menu-bar-mode nil)
 '(package-archives
   (quote
    (("melpa" . "https://melpa.org/packages/")
     ("melpa-stable" . "https://stable.melpa.org/packages/")
     ("gnu" . "https://elpa.gnu.org/packages/")
     ("org" . "http://orgmode.org/elpa/"))))
 '(package-selected-packages
   (quote
    (editorconfig rust-mode toml-mode org-mode ergoemacs-mode git-gutter-fringe emmet-mode sass-mode web-mode multiple-cursors powershell groovy-mode highlight-symbol window-purpose restclient-test restclient tuareg markdown-mode idris-mode magit ahg rainbow-delimiters rainbow-delimiters-mode haskell-mode fsharp-mode smex ido-vertical-mode auctex color-theme-sanityinc-tomorrow use-package persistent-soft)))
 '(ring-bell-function (quote ignore))
 '(sentence-end-double-space nil)
 '(show-paren-mode t)
 '(tab-stop-list
   (quote
    (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120)))
 '(tool-bar-mode nil)
 '(use-package-always-ensure t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:height 80 :family "DejaVu Sans Mono")))))
