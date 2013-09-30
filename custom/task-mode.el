; http://www.emacswiki.org/emacs/GenericMode
; Try adding my own minor mode for taskpaper, that really just offers syntax highlighting
(require 'generic-x)
(define-generic-mode
    'task-mode ;name of the mode
  '("---") ;how comments are defined in mode
  '("@done" "@later" "@testing" "@important" "@non-happen") ;keywords
  nil ;operators
  '("\\.txt$", "\\.taskpaper$", "\\.todo$", "\\.tasks$") ;filenames to activate this mode for
  (list (lambda () (highlight-lines-matching-regexp "\\@done" "hi-green-b")) ;my line colors
        (lambda () (highlight-lines-matching-regexp "\\@later" "hi-blue-b"))
        (lambda () (highlight-lines-matching-regexp "\\@testing" "hi-yellow-b"))
        (lambda () (highlight-lines-matching-regexp "\\@important" "hi-red-b"))
        (lambda () (highlight-lines-matching-regexp "\\@non-happen" "hi-gray-b")))
  "A mode for task files")
  

(defun task-mode-archive-done ()
  ; Archive all the done tasks at the bottom of the page
  (interactive)
  (save-excursion
    (evil-normal-state)
    (goto-char (point-min))
    (while (re-search-forward "@done" nil t)
      (message (format "%i / %i / %i" (point) (line-beginning-position) (line-end-position)))
      (let ((cur-pos (point)))
        (evil-delete-line (line-beginning-position) (+ 1 (line-end-position)))
        (delete-backward-char 1)
        (goto-char (point-max))
        (evil-insert-newline-below)
        (evil-paste-after 1)
        (forward-line 1)
        (goto-char (line-beginning-position))
        (re-search-forward "@done" nil t)
        (replace-match "@archive")
        ;(evil-ex-substitute (line-beginning-position) (line-end-position) "@done" "@archive")
        (goto-char cur-pos); and back to the original posiiton
        (forward-line -1) ; and go one up
      ))))


(defun task-mode-todo-task ()
  ; add '@done to the end of the line
  (interactive)
  (task-mode-insert-at-end "@done"))

(defun task-mode-testing-task ()
  (interactive)
  (task-mode-insert-at-end "@testing"))

(defun task-mode-later-task ()
  (interactive)
  (task-mode-insert-at-end "@later"))

(defun task-mode-important-task ()
  (interactive)
  (task-mode-insert-at-end "@important"))

(defun task-mode-nonhappen-task ()
  (interactive)
  (task-mode-insert-at-end "@non-happen"))

(defun task-mode-insert-at-end (text)
  (save-excursion
    (goto-char (line-end-position))
    (insert (format " %s" text))))


(provide 'task-mode)
