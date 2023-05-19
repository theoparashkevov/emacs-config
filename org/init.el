(require 'package)
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("elpa" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(require 'yasnippet)
(yas-global-mode 1)

(add-hook 'after-init-hook #'global-company-mode)
(add-hook 'after-init-hook #'global-flycheck-mode)

(require 'company)
(setq company-backends '(
			  company-jedi company-bbdb company-semantic company-cmake company-capf company-clang company-files
		(company-dabbrev-code company-gtags company-etags company-keywords)
		company-oddmuse company-dabbrev
			  )
      )

;(setq py-auto-complete-p nil)
(setq python-indent-guess-indent-offset nil)
(setq python-indent-offset 4)
(setq python-shell-completion-native-disabled-interpreters '("pypy" "ipython" "python3.9"))
(setq python-shell-interpreter "python3.9")
