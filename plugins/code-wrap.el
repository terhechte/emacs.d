(define-minor-mode code-wrap-mode
	"Visually wrap the buffer text to the previous lines indent, plus a tab."
	:lighter ""
	(if code-wrap-mode
		(progn 
			(visual-line-mode 1)
			(jit-lock-register #'indent-prefix-wrap-function))
		(visual-line-mode 0)
		(jit-lock-unregister #'indent-prefix-wrap-function)
		(with-silent-modifications
			(save-restriction
				(widen)
				(remove-text-properties (point-min) (point-max) '(wrap-prefix nil))))))
 
(setq indent-prefix-extra "\t")
(defun indent-prefix-wrap-function (&optional beg end)
	"Indent the region between BEG and END with the existing indent, plus a little extra."
	(when (and beg end)
		(let ((tab-as-spaces (string-repeat " " tab-width)))
			(goto-char beg)
			(beginning-of-line)
			(while (< (point) end)
				(let* ((line-start (point))
					   (indent-start (progn (skip-syntax-forward " " end) (point)))
					   (line-end (progn (beginning-of-line 2) (- (point) 1)))
					   (prefix (concat (buffer-substring line-start indent-start) indent-prefix-extra)))
					;; replace tabs with spaces because the tab indent gets messed up
					(setq prefix (replace-regexp-in-string "\t" tab-as-spaces prefix))
					;; if we are indenting more than half the window width, give up and go back to a one-tab indent
					(when (> (length prefix) (/ (window-width) 2))
						(setq prefix tab-as-spaces))
					(put-text-property line-start line-end 'wrap-prefix prefix))))))

(provide 'code-wrap)
