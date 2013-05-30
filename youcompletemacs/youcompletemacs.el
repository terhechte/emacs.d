(provide 'youcompletemacs)
(require 'cl)
(require 'auto-complete)
(require 'epc)

; Todo:
; - stop the epc process when killing buffer / etc
; - send over the modified buffer instead of reading the file from disk, otherwise we'd need to save everytime we do completion

(defvar yce-async-do-autocompletion-automatically t
  "If autocompletion is automatically triggered when you type ., -> or ::")

(defvar yce-status 'idle
  "are we currently waiting for results? ")

(defvar yce-python-results nil
  "the last results we got from python")

(defvar yce-last-result-state nil
  "the file info for the last result")

(defun yce-file-info ()
  (list "filename.m" "folder" (line-number-at-pos) (current-column)))

(defun yce-current-file-info ()
  (let ((keys (list 'file 'folder 'column 'row))
        (vals (yce-file-info)))
        (pairlis keys vals)))

(defun yce-call-python ()
  (setq yce-status 'working)
  (deferred:$
    (epc:call-deferred yce-epc 'getCompletionsForQuery
    (yce-file-info)) 
    ;(epc:call-deferred yce-epc 'echo '(10))
    (deferred:nextc it
      (lambda (x) (yce-got-python-results x)))))

(defun yce-candidate ()
  ; if we have a new result state, we change the mode back to idle
  (unless (every 'equal (yce-current-file-info) yce-last-result-state)
    (setq yce-status 'idle))

  (case yce-status

    ;; We're waiting for a request, go and request
    (idle
     (print "call again")
     (setq yce-python-results nil)

     ; save the last result state
     (setq yce-last-result-state (yce-current-file-info))

     (yce-call-python)
     (setq yce-status 'working))
    )
   ; Return current value
  yce-python-results)

; Create the Python process
(defun yce-launch-completion-process ()
    (setq yce-epc (epc:start-epc "python" '("/Users/terhechte/.emacs.d/youcompletemacs/yce-server.py"))))

;(require 'epc)
;(defvar yce-epc (epc:start-epc "python" '("/Users/terhechte/.emacs.d/youcompletemacs/yce-server.py")))

(defun yce-got-python-results (results)
  ;(print "python result")
  (setq yce-python-results results)
  (ac-start :force-init t)
  (ac-update)
  (setq yce-status 'done)
  )

(defun yce-async-autocomplete-autotrigger ()
  (print "autotrigger")
  (interactive)
  (if yce-async-do-autocompletion-automatically
    (yce-async-preemptive)
    (self-insert-command 1)))

(defun yce-async-preemptive ()
  (print "preemptive")
  (interactive)
  (self-insert-command 1)
  (if (eq yce-status 'idle)
    (ac-start)
    ))

(defun yce-objc-prefix ()
  ;; ObjC Completion is done for three different use cases:
  ;; 1. If the user typed at least 3 chars right after ^
  ;; 2.1 If the user typed a '.' after at least a [a-zA-Z]
  ;; 2.2 If the user continues typing after . (i.e. a.numberOf..)
  ;; 3.1 If the user typed a '[' with at least 3 chars
  ;; 3.2 If the user types a ' ' after a '[' with [a-zA-Z0-9] (i.e. [nr9 ...)

  
   ; (if (< pos (line-beginning-position))
   ;     nil
   ;   (if (eq (char-after pos) (string-to-char "["))
   ;       (point)
   ;     (is-objc-method (- pos 1))))
  
  (defun is-objc-method (pos)
    ; (message "search pos: %S" (number-to-string pos))
    ; (message "testing: '%S'" (char-before pos))
    (cond ((< pos (line-beginning-position)) nil) ; end of line
          ((eq (char-before pos) (string-to-char " ")) nil) ; found a ' '
          ((eq (char-before pos) (string-to-char "[")) (point)) ; found a [
          (t (is-objc-method (- pos 1))) ; continue searching
     )
    )

  ; (message "testing: '%S'" (char-before (point)))
  (if (eq (char-before) (string-to-char "."))
      (point)
    (if (eq (char-before) (string-to-char " "))
        (is-objc-method (- (point) 1))
      nil)))

 ; Debug code to test our functions
; (defun testfind ()
;   (interactive)
;   (if (yce-objc-prefix)
;       (message "has [")
;     (message "not has [")))
; 
; (global-set-key (kbd "@") 'testfind)

(ac-define-source fobjcm
'((candidates . yce-candidate) ;req-candidates
  (prefix . yce-objc-prefix) ; yce-objc-prefix 
  (requires . 0)) ;
  )

(defun yce-mode-setup ()
  (setq ac-sources '(ac-source-fobjcm))
  (yce-launch-completion-process)
)

(defun yce-config ()
  (add-hook 'c-mode-common-hook 'yce-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))

(yce-config)
