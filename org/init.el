(require 'company)
(setq company-backends '((
			  company-jedi company-bbdb company-semantic company-cmake company-capf company-clang company-files
		(company-dabbrev-code company-gtags company-etags company-keywords)
		company-oddmuse company-dabbrev
			  ))
      )
