(require 'org)
(setq magit-last-seen-setup-instructions "1.4.0")
(org-babel-load-file "~/.emacs.d/init-el.org")

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :height 80 :family "Bitstream Vera Sans Mono"))))
 '(fsharp-error-face ((t (:inherit error))))
 '(helm-ff-directory ((t (:background nil))))
 '(highlight ((t (:background "#333" :foreground "white")))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(delete-selection-mode t)
 '(indent-tabs-mode nil)
 '(initial-scratch-message nil)
 '(org-CUA-compatible nil)
 '(org-replace-disputed-keys nil)
 '(recentf-mode t)
 '(shift-select-mode nil))
