;;; Display-related stuff.
;;; Put it first to minimize flickering on startup.
(tool-bar-mode 0)
(menu-bar-mode 0)
(column-number-mode 1)
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)

;;; Custom variables.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-by-copying t)
 '(backup-directory-alist (quote (("." . "~/.saves"))))
 '(compilation-scroll-output (quote first-error))
 '(custom-safe-themes (quote ("06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" default)))
 '(delete-old-versions t)
 '(display-time-day-and-date t)
 '(display-time-mode t)
 '(fill-column 79)
 '(fsharp-indent-offset 4)
 '(global-rainbow-delimiters-mode t)
 '(haskell-program-name "ghci")
 '(ido-mode (quote both) nil (ido))
 '(kept-new-versions 6)
 '(kept-old-versions 2)
 '(org-startup-folded nil)
 '(sentence-end-double-space t)
 '(show-paren-mode 1)
 '(tab-stop-list (quote (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120)))
 '(version-control t))

;; Some misc options that are not in Customize.
(setq ring-bell-function 'ignore)
(fset 'yes-or-no-p 'y-or-n-p)
;; (setq fsharp-ac-executable "tail")	; dirty way to deactivate ac in F#
(setq inferior-fsharp-program "fsharpi")
(defun fsharp-set-keybindings ()
  (define-key fsharp-mode-map (kbd "M-<return>") 'fsharp-eval-region)
  (define-key fsharp-mode-map (kbd "C-M-x") 'fsharp-eval-phrase)
  (define-key fsharp-mode-map (kbd "C-<tab>") 'fsharp-ac/complete-at-point))
(add-hook 'fsharp-mode-hook 'fsharp-set-keybindings)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :height 90 :family "Consolas"))))
 '(fsharp-error-face ((t (:inherit error))))
 '(highlight ((t (:background "#333" :foreground "white")))))

;;; Install packages from MELPA.
(package-initialize)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-installed-p 'package+)
(unless (package-installed-p 'package+)
  (package-refresh-contents)
  (package-install 'package+))
;; The list of packages. Install missing packages, uninstall extra ones.
(package-manifest
 'ahg
 'color-theme-sanityinc-tomorrow
 'ergoemacs-mode
 'fsharp-mode
 'haskell-mode
 'highlight-symbol
 'magit
 'package+
 'rainbow-delimiters)

;;; Color theme.
(load-theme 'sanityinc-tomorrow-night)

;;; Haskell mode
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(define-key haskell-mode-map (kbd "C-c C-r") 'inferior-haskell-reload-file)

;;; Highlight-symbol
(global-set-key (kbd "M-s") 'highlight-symbol-at-point)
(global-set-key (kbd "M-S") 'highlight-symbol-remove-all)

;;; Use [pause] to fix a buffer in a window, and don't create new windows
;;; for newly created buffers.
(defadvice pop-to-buffer (before cancel-other-window first)
  (ad-set-arg 1 nil))
(ad-activate 'pop-to-buffer)
;; Toggle window dedication
(defun toggle-window-dedicated ()
  "Toggle whether the current active window is dedicated or not"
  (interactive)
  (message
   (if (let (window (get-buffer-window (current-buffer)))
         (set-window-dedicated-p window 
                                 (not (window-dedicated-p window))))
       "Window '%s' is dedicated"
     "Window '%s' is normal")
   (current-buffer)))
;; Press [pause] key in each window you want to "freeze"
(global-set-key [pause] 'toggle-window-dedicated)
(setq pop-up-windows nil)

;;; ErgoEmacs + custom general keyboard shortcuts.
(require 'ergoemacs-mode)
(setq ergoemacs-keyboard-layout "dv")
(ergoemacs-mode)
(global-set-key (kbd "M-v") 'ergoemacs-beginning-or-end-of-buffer)
(global-set-key (kbd "M-w") 'switch-to-buffer)
(global-set-key (kbd "M-m") 'back-to-indentation)
(global-set-key (kbd "M-3") 'delete-other-windows)
(global-set-key (kbd "M-0") 'delete-window)
(global-set-key (kbd "S-<tab>") 'tab-to-tab-stop)
(global-set-key (kbd "C-M-S-b") 'compile)
(global-set-key (kbd "C-B") 'recompile)
