; Try adding my own minor mode for taskpaper, that really just offers syntax highlighting
; This mode currently utilizes evil functionality, since I use emacs with evil. It would be trivial to make
; this a full major mode that does not depend upon evil, but this is more or less a small project for me
; to create the perfect todo mode, and to learn more emacs & more elisp
; http://www.emacswiki.org/emacs/GenericMode
(require 'generic-x)
(define-generic-mode
    'task-mode ;name of the mode
  '("---") ;how comments are defined in mode
  '("@done" "@later" "@testing" "@important" "@non-happen") ;keywords
  nil ;operators
  '("\\.txt$" "\\.taskpaper$" "\\.todo$" "\\.tasks$") ;filenames to activate this mode for
  (list (lambda () (highlight-lines-matching-regexp "\\@done" "hi-green-b")) ;my line colors
        (lambda () (highlight-lines-matching-regexp "\\@later" "hi-blue-b"))
        (lambda () (highlight-lines-matching-regexp "\\@testing" "hi-yellow-b"))
        (lambda () (highlight-lines-matching-regexp "\\@important" "hi-red-b"))
        (lambda () (highlight-lines-matching-regexp "\\:$" "hi-pink"))
        (lambda () (highlight-lines-matching-regexp "\\:$" "hi-blue-b"))
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
  ; add '@done to the end of the line, also add the time when it was done
  (interactive)
  (task-mode-insert-at-end (format "@done (@%s)" (current-time-string))))

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
  ; mark function
  (defun mark-with-text (text)
    (goto-char (line-end-position))
    (insert (format " %s" text)))
  (save-excursion
    ; if we have a region active, go through all lines                                       
    (if (region-active-p)
        (let ((org-region (region-end))
              (start-point (if (< (region-end) (region-beginning))
                               (region-end)
                             (region-beginning))))
          (goto-char start-point)
          (while (<= (point) org-region)
            (message "mark-active")
            (mark-with-text text)
            (goto-char (line-beginning-position))
            (forward-line 1)))
      ; Else, just mark the one line
      (mark-with-text text))))

(defun task-mode-new-todo (task)
  ; Add a new todo
  (interactive "sEnter Task: ")
    (evil-normal-state)
    (evil-insert-newline-below)
    (insert (format "- %s (%s)" task (current-time-string)))
    (goto-char (line-beginning-position)))

(provide 'task-mode)
