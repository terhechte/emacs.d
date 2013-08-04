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

(defvar yce-buffer " *yce output*")

(defun yce-logger (errString)
  (with-current-buffer (get-buffer-create yce-buffer)
    (normal-mode)
    (setq-local buffer-read-only nil)
    (buffer-disable-undo)
    (goto-char (point-max))
    (insert errString)
    (setq-local buffer-read-only t)))

; get a list of all buffers, including their content, and modified flag
(defun yce-list-of-buffers ()
  ; we store the current buffer, so we can later make it current again
  (setq actual-current-buffer (current-buffer))
  (setq result (mapcar (lambda (x) (set-buffer x) (list (buffer-name x) (buffer-modified-p x) (buffer-string))) (buffer-list)))
  (set-buffer actual-current-buffer)
  result)

(defun yce-file-info ()
  (let ((px (buffer-file-name)))
    (list (file-name-nondirectory (if px px "")) (file-name-directory (if px px "")) (line-number-at-pos) (current-column))
    ))
;(print (yce-file-info))

(defun yce-current-file-info ()
  (let ((keys (list 'file 'folder 'column 'row))
        (vals (yce-file-info)))
        (pairlis keys vals)))

(defun yce-call-python ()
  (message "call python")
  (setq yce-status 'working)
  ; submit the list of buffers, async, 
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
     (message "call again")
     (setq yce-python-results nil)

     ; TEMPORARY! We save the buffer
     ; This only until we can send the buffer over to YCM
     (save-buffer)

     ; save the last result state
     (setq yce-last-result-state (yce-current-file-info))

     (yce-call-python)
     (setq yce-status 'working))
    )
   ; Return current value
  yce-python-results)

; Create the Python process
(defun yce-launch-completion-process ()
  ;(defvar clancs-epc-client (epc:start-epc "python" (list (concat clancs-path "clancs.py"))))
    (setq yce-epc (epc:start-epc "python" '("/Users/terhechte/.emacs.d/youcompletemacs/yce-server.py")))

  ;; Initialize the server
  (defvar yce-epc-server (epcs:server-start
			       (lambda (manager)
				 (epc:define-method manager 'log 'yce-logger "args" "Log to the *yce* buffer")
				 )))
  ;; Communicate emacs server port to python server (and hence the client)
  (epc:call-sync clancs-epc-client 'init_client
		 (list (epcs:server-port (cdr (assoc clancs-epc-server epcs:server-processes)))))

  (message "Clancs initialized."))

(defun yce-kill ()
  (epc:stop-epc yce-epc)
  (epcs:server-stop yce-epc-server)
  (makunbound 'yce-epc)
  (makunbound 'yce-epc-server))

; Create our server that receives data from the python process

;(require 'epc)
;(defvar yce-epc (epc:start-epc "python" '("/Users/terhechte/.emacs.d/youcompletemacs/yce-server.py")))

(defun yce-got-python-results (results)
  (message "python result")
  (setq yce-python-results results)
  (message (car results))
  (print results)
  (ac-start :force-init t)
  (ac-update)
  (setq yce-status 'done)
  )

(defun yce-async-autocomplete-autotrigger ()
  (message "autotrigger")
  (interactive)
  (if yce-async-do-autocompletion-automatically
    (yce-async-preemptive)
    (self-insert-command 1)))

(defun yce-async-preemptive ()
  (message "preemptive")
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
(provide 'youcompletemacs)
