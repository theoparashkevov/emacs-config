
;; (load-theme 'modus-vivendi )
;; (setq modus-themes-mode-line 'accented)

(add-to-list 'load-path "~/.config/emacs/static/")

(require 'org)
(org-babel-load-file
 (expand-file-name "init.org" "~/.config/emacs/org/")
)

(setq org-support-shift-select t)
(setq tool-bar-mode nil)

(require 'multi-term)
(setq multi-term-program "/bin/bash")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(yasnippet-snippets which-key vterm visual-fill-column use-package typescript-mode rainbow-delimiters pyvenv python-mode py-snippets org-bullets lsp-ui lsp-jedi lsp-ivy lsp-docker jedi ivy-rich helpful general forge flycheck evil-nerd-commenter evil eterm-256color eshell-git-prompt doom-themes doom-modeline dired-single dired-open dired-hide-dotfiles dap-mode counsel-projectile company-shell company-jedi company-box command-log-mode annalist all-the-icons-dired)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
