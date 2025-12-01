;;; init.el --- Emacs configuration -*- lexical-binding: t; -*-
;;; Commentary:
;;; Personal Emacs setup
;;; Code:

;; ----------------------------
;; PACKAGE INITIALIZATION
;; ----------------------------
(require 'package)
(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; Ensure use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(setq use-package-always-ensure t)

;; ----------------------------
;; RECENT FILES / HISTORY
;; ----------------------------
(use-package recentf
  :init
  (recentf-mode 1)
  :config
  (setq recentf-max-menu-items 50
        recentf-max-saved-items 200))

(savehist-mode 1)

;; ----------------------------
;; PROJECT MANAGEMENT
;; ----------------------------
(use-package projectile
  :init
  (projectile-mode 1)
  :config
  (setq projectile-project-search-path '("~/projects")))

;; ----------------------------
;; TRAMP SETTINGS
;; ----------------------------
(require 'tramp)

(setq tramp-default-method "ssh"
      tramp-verbose 1
      tramp-persistency-file-name "~/.emacs.d/tramp-history.el"
      tramp-use-ssh-controlmaster-options t)

;; Auto-bookmark new servers visited via TRAMP
(defun my-tramp-auto-bookmark ()
  "Bookmark newly visited TRAMP directories."
  (when (and default-directory
             (file-remote-p default-directory))
    (bookmark-set
     (format "ssh:%s"
             (tramp-file-name-host
              (tramp-dissect-file-name default-directory)))
     nil)))

(add-hook 'dired-mode-hook #'my-tramp-auto-bookmark)

;; ----------------------------
;; DASHBOARD (HOME PAGE)
;; ----------------------------
(use-package all-the-icons
  :if (display-graphic-p))

(use-package dashboard
  :init
  (setq dashboard-startup-banner 'official
        dashboard-center-content t
        dashboard-set-heading-icons t
        dashboard-set-file-icons t

        dashboard-navigator-buttons
        `((("Open File" "f" #'find-file "📄")
           ("Recent Files" "r" #'recentf-open-files "🕘")
           ("Connect Server" "s"
            (lambda () (find-file "/ssh:")) "🌐")
           ("Bookmarks" "b" #'list-bookmarks "🔖")))

        dashboard-items '((recents   . 10)
                          (projects . 10)
                          (bookmarks . 10)
                          (agenda . 5)))
  :config
  (dashboard-setup-startup-hook))

(global-set-key (kbd "C-c h") #'dashboard-open)

;; ----------------------------
;; AIDER / AUTOMATION
;; ----------------------------
(use-package aidermacs
  :bind (("C-c a" . aidermacs-transient-menu))
  :config
  (aidermacs-setup-minor-mode)

  (setq aidermacs-auto-commits t
        aidermacs-default-model "gpt-5-mini"
        aidermacs-default-chat-mode 'architect)

  ;; IMPORTANT:
  ;; Set your OPENAI_API_KEY in your shell environment
  ;; export OPENAI_API_KEY="sk-xxxx"
  (setenv "OPENAI_API_KEY" "<openai_api_key>")


  (when (fboundp 'aider-magit-setup-transients)
    (aider-magit-setup-transients))

  (global-auto-revert-mode 1))

;; ----------------------------
;; MAGIT
;; ----------------------------
(use-package magit
  :commands (magit-status magit-log)
  :bind (("C-x g" . magit-status))
  :config
  (setq magit-display-buffer-function
        #'magit-display-buffer-same-window-except-diff-v1))

(use-package transient
  :after magit)

;; ----------------------------
;; FLYCHECK
;; ----------------------------
(use-package flycheck
  :config
  (global-flycheck-mode 1))

;; ----------------------------
;; LSP MODE
;; ----------------------------
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l"
        lsp-prefer-flymake nil)
  :hook ((python-mode . lsp-deferred)
         (js-mode . lsp-deferred)
         (typescript-mode . lsp-deferred)
         (c-mode . lsp-deferred)
         (c++-mode . lsp-deferred))
  :config
  (setq lsp-idle-delay 0.5
        lsp-completion-provider :capf
        lsp-headerline-breadcrumb-enable t))

;; ----------------------------
;; LSP UI
;; ----------------------------
(use-package lsp-ui
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-peek-enable t
        lsp-ui-peek-show-directory t
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-code-actions t
        lsp-ui-sideline-delay 0.3

        lsp-ui-doc-enable t
        lsp-ui-doc-show-with-cursor t
        lsp-ui-doc-show-with-mouse nil
        lsp-ui-doc-position 'at-point

        ;; OK even in -nw since childframes auto-disable
        lsp-ui-doc-use-childframe t

        lsp-ui-doc-include-signature t
        lsp-ui-imenu-enable t)

  ;; Remap xref to peek
  (define-key lsp-mode-map [remap xref-find-definitions]
    #'lsp-ui-peek-find-definitions)
  (define-key lsp-mode-map [remap xref-find-references]
    #'lsp-ui-peek-find-references))

;; ----------------------------
;; PYRIGHT (Python LSP)
;; ----------------------------
(use-package lsp-pyright
  :after lsp-mode
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp-deferred))))

(defun my/use-project-venv-python ()
  "Use project-local .venv Python if available."
  (when-let* ((proj (project-current))
              (root (project-root proj))
              (venv (expand-file-name ".venv" root))
              (py (expand-file-name "bin/python" venv)))
    (when (file-executable-p py)
      (setq-local lsp-pyright-python-executable-cmd py))))

(add-hook 'python-mode-hook #'my/use-project-venv-python)

;; ----------------------------
;; COMPLETION
;; ----------------------------
(use-package company
  :config
  (global-company-mode 1))

(use-package which-key
  :config
  (which-key-mode 1))

;; ----------------------------
;; THEME & COSMETICS
;; ----------------------------
(load-theme 'leuven-dark t)

(tool-bar-mode -1)

;; ----------------------------
;; FINAL PROVIDE
;; ----------------------------
(provide 'init)
;;; init.el ends here

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
