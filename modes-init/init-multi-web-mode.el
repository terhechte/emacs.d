;; Configure multi-web-mode
;(require 'multi-web-mode)
;
;(setq mweb-default-major-mode 'nxml-mode)
;(setq mweb-tags '((php-mode
;                   "<\\?php\\|<\\? \\|<\\?=" "\\?>")
;                  (js-mode 
;                   "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
;                  (js-mode          
;                   "<script +\\(type=\"application/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
;                  (mustache-mode    
;                   "<script +\\(type=\"text/html\"\\)[^>]*>" "</script>")
;                  (handlebars-mode
;                   "<script +\\(type=\"text/text/x-handlebars-template\"\\)[^>]*>" "</script>")
;                  (nxml-mode
;                   "<script +\\(type=\"text/text/x-kendo-template\"\\)[^>]*>" "</script>")
;                  (css-mode
;                   "<style +type=\"text/css\"[^>]*>" "</style>")))
;
;(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5" "erb"))
;(multi-web-global-mode 1)
;
;(provide 'init-multi-web-mode)

(require 'web-mode)

(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.blade\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist
'("/\\(views\\|html\\|theme\\|templates\\)/.*\\.php\\'" . web-mode))



(eval-after-load 'web-mode
  '(progn
     (defun prelude-web-mode-defaults ()
       ;; Disable whitespace-mode when using web-mode
       (whitespace-mode -1)
       ;; Customizations
       (setq web-mode-markup-indent-offset 4)
       (setq web-mode-css-indent-offset 2)
       (setq web-mode-code-indent-offset 4)
       (setq web-mode-disable-autocompletion t)
       (local-set-key (kbd "RET") 'newline-and-indent))
     (setq prelude-web-mode-hook 'prelude-web-mode-defaults)

     (add-hook 'web-mode-hook (lambda ()
                                 (run-hooks 'prelude-web-mode-hook)))))


(provide 'init-multi-web-mode)
