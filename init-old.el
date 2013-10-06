; Code that has been depcrecated from my init.el but that I may
; want to activate again at a later point in time, but I
; really don't want it clobbering up my init.el
; I also don't want to hunt down my git history


(require 'package)
(add-to-list 'package-archives
               '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives 
                 '("marmalade" .
                         "http://marmalade-repo.org/packages/"))
(package-initialize)


(defun yce-setup ()
  (interactive)
  (auto-complete-mode 1)
  (require 'youcompletemacs))
     
;; You Complete mEmacs
(require 'youcompletemacs)
(add-to-list 'ac-modes 'objc-mode)
(add-hook 'objc-mode-hook (lambda ()
          (message "objc mode hook")
          (auto-complete-mode 1)
          (yce-config)))




;; Irony Mode trying
(add-to-list 'load-path (expand-file-name "~/.emacs.d/irony-mode/elisp/"))
(require 'auto-complete)
(require 'irony)
(irony-enable 'ac)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)



; this should make always abbrev everything, not working though yet
(defun start-auto-complete ()
  (interactive)
  (require 'auto-complete)
  (global-auto-complete-mode t)
  (define-key ac-complete-mode-map "\C-n" 'ac-next)
  (define-key ac-complete-mode-map "\C-p" 'ac-previous)
  (setq ac-auto-start 3)
  (define-key ac-complete-mode-map "\M-/" 'ac-stop)
  )

