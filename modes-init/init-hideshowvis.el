(when (window-system)
  (require 'hideshowvis)

  (dolist (hook (list 'emacs-lisp-mode-hook
                      'lisp-mode-hook
                      'ruby-mode-hook
                      'perl-mode-hook
                      'php-mode-hook
                      'python-mode-hook
                      'lua-mode-hook
                      'c-mode-hook
                      'java-mode-hook
                      'js-mode-hook
                      'css-mode-hook
                      'c++-mode-hook))
    (add-hook hook 'hideshowvis-enable)))

(provide 'init-hideshowvis)
