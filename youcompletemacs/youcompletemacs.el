(provide 'youcompletemacs)
(require 'cl)
(require 'auto-complete)
(require 'epc)

; stopping
; (epc:stop-epc "python")

(defvar yce-async-do-autocompletion-automatically t
  "If autocompletion is automatically triggered when you type ., -> or ::")

(defvar yce-status 'idle
  "are we currently waiting for results? ")

;(defvar yce-python-results nil
;  "the last results we got from python")
(setq yce-python-results nil)

(defun yce-call-python
  ()
  (message "call python")
  (setq yce-status 'working)
  (deferred:$
    (epc:call-deferred yce-epc 'echo '(10))
    (deferred:nextc it
      (lambda (x) (yce-got-python-results x)))))

;(defun yce-candidate ()
;  (message "candidate")
;  (if (eq yce-status 'idle)
;    (yce-call-python))
;  yce-python-results)

(defun yce-candidate ()
  (message "candidate")
  (case yce-status

    ;; We're waiting for a request, go and request
    (idle
      (message "candidate idel: with: %S" (car yce-python-results))
      (setq yce-python-results nil)
      (yce-call-python)
      (setq yce-status 'working))

    ;; We're currently requesting
    (working
      (message "candidate working with: %S" (car yce-python-results)))
    )
  ; Return current value
  yce-python-results
  )

; Set up some python
(defvar yce-epc (epc:start-epc "python" '("/Users/terhechte/.emacs.d/youcompletemacs/yce-server.py")))

(defun yce-got-python-results
  (results)
  (message "Got results!")
  (message (car results))
  ;(setq yce-python-results (list "sarbatka" "wernsman" "aaabc" "aaacc"))
  (setq yce-python-results results)
  (ac-start :force-init t)
  (ac-update))

(defun yce-prefix ()
  (or (ac-prefix-symbol)
      (let ((c (char-before)))
        (when (or (eq ?\. c)
                  ;; ->
                  (and (eq ?> c)
                       (eq ?- (char-before (1- (point)))))
                  ;; ::
                  (and (eq ?: c)
                       (eq ?: (char-before (1- (point))))))
          (point)))))

(defun yce-async-autocomplete-autotrigger ()
  (interactive)
  ;(print "autotrigger")
  (message "autotrigger %S" (number-to-string (random 100)))
  (if yce-async-do-autocompletion-automatically
    (yce-async-preemptive)
    (self-insert-command 1)))

(defun yce-async-preemptive ()
  (interactive)
  (self-insert-command 1)
  (if (eq yce-status 'idle)
    (message "is idle")
    )
  (if (eq yce-status 'idle)
    (ac-start)
    ))

(defface ac-clang-candidate-face
  '((t (:background "lightgray" :foreground "navy")))
  "Face for clang candidate"
  :group 'auto-complete)

(defface ac-clang-selection-face
  '((t (:background "navy" :foreground "white")))
  "Face for the clang selected candidate."
  :group 'auto-complete)

(defun yce-objc-prefix ()
  (message "Req prefix")
  ;We complete, if *either* the current character is a '.'
  ;or, if any previous character is a '['"
  (defun is-objc-method (pos)
    (if (< pos (line-beginning-position))
        nil
      (if (eq (char-after pos) (string-to-char "["))
          (point)
        (is-objc-method (- pos 1))))
    )
  (if (eq (char-before) (string-to-char "."))
      (point)
    (is-objc-method (point))))

(defun lalala ()
  (let ((px (yce-objc-prefix)))
    (message "returned: %S" (if px (number-to-string px) "nil"))
    px
    )
  )
; Debug code to test our functions
; (defun testfind ()
;   (interactive)
;   (if (yce-objc-prefix)
;       (message "has [")
;     (message "not has [")))
; 
; (global-set-key (kbd "@") 'testfind)

;(ac-define-source sctest1
;  '((candidates . yce-candidate) ;; ;; 
;    (candidate-face . ac-clang-candidate-face)
;    (selection-face . ac-clang-selection-face)
;    (requires . 0)
;    (prefix . yce-objc-prefix))) ;yce-prefix

(defun req-candidates ()
  (message "Request Candidates")
  (list "stringWithFormat:" "stringWithString" "stringWithCString")
  )

(ac-define-source fobjcm
'((candidates . req-candidates)
  (prefix . yce-objc-prefix) ;yce-objc-prefix
  (requires . 0)) ;
  )

(defun yce-cc-mode-setup ()
  (message "yeah2")
  ;(setq ac-sources '(ac-source-sctest1))
  (setq ac-sources '(ac-source-fobjcm))
  ;(ac-clang-launch-completion-process)
)

(defun my-yce-config ()
  ;(message "yeah")
  (add-hook 'c-mode-common-hook 'yce-cc-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  ;(global-set-key (kbd "@") 'yce-async-autocomplete-autotrigger)
  ;(global-set-key (kbd "#") 'yce-async-autocomplete-autotrigger)
  (global-auto-complete-mode t))

(my-yce-config)
