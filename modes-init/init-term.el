(when (require 'multi-term nil t)
  (global-set-key (kbd "<f5>") 'multi-term)
  (global-set-key (kbd "<s-next>") 'multi-term-next)
  (global-set-key (kbd "<s-prior>") 'multi-term-prev)
  (setq multi-term-scroll-to-bottom-on-output nil)
  (setq multi-term-buffer-name "ansi-term"
        multi-term-program "/bin/zsh"))

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines) ; edit multicursors on all selected lines
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click) ; edit multicursors on mouse positions
(global-set-key (kbd "C->") 'mc/mark-next-like-this) ; multiple cursors on next word like this
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this) ; on previous
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(provide 'init-term)
