
(load-theme 'modus-vivendi )
(setq modus-themes-mode-line 'accented)

(require 'org)
(org-babel-load-file
 (expand-file-name "init.org" "/home/tcv/.config/emacs/org/")
 )

(setq org-support-shift-select t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(lsp-jedi jedi company-shell company-jedi company py-snippets yasnippet-snippets flycheck python-mode yasnippet use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
