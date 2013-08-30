(defun create-column (name type)
  (setq tp (split-string name "_"))
  (setq oname (car (cdr tp)))
  (setq vname (if oname oname name))
  (setq vname2 (if oname name (format "bo_%s" name)))
    (insert (format "  def %s = column[%s] (\"%s\")\n" vname type vname2))
  )

(defun create-icolumn (name)
  "Insert a complete column description"
  (interactive "Mname:")
  (create-column name "Int")
  )
(global-set-key (kbd "C-c C-1") 'create-icolumn)

(defun create-scolumn (name)
  "Insert a complete sttring comlumn description"
  (interactive "Mname:")
  (create-column name "String")
  )
(global-set-key (kbd "C-c C-2") 'create-scolumn)

(defun create-dcolumn (name)
  "Insert a complete double column description"
  (interactive "Mname:")
  (create-column name "Double")
  )
(global-set-key (kbd "C-c C-3") 'create-dcolumn)

; retrieve url, and switch to buffer
(defun get-buf-url (url)
  (interactive "surl to fetch:")
  (url-retrieve url
                (lambda (status) (switch-to-buffer (current-buffer)))))

(require 'request)
(defun get-msg-url (url)
  (interactive "surl to fetch:")
  (request url
           :success (function*
                     (lambda (&key data &allow-other-keys)
                       (let* ((html (elt (assoc-default 'results data) 0)))
                         (message "data is: %s" html))))))

; quickly set up the database
(defun setup-audition ()
  (interactive)
  (let* ((base-url "http://localhost:8081/admin/")
        (setup-url (concat base-url "setupdb"))
        (create-url (concat base-url "createdata"))
        (read-url (concat base-url "data"))
        (empty-lam (lambda (x) ())))
    (url-retrieve setup-url empty-lam)
    (sleep-for 1.0)
    (url-retrieve create-url empty-lam)
    (sleep-for 1.0)
    (get-buf-url read-url)
    )
  )

; quickly restart the audition
(defun sbt-startup-done ()
  (goto-char (point-max))
  (if (string-equal (current-word) ">")
      t
    nil))

(defun audition-restart ()
  (interactive)
  (let ((buf (get-buffer "sbt")))
    (with-current-buffer buf
        (set-buffer buf)
        (evil-insert 1)
        (term-send-raw-string (kbd "C-c RET"))
        (term-send-raw-string (kbd "C-c RET"))
        (term-send-raw-string "./sbt\n")
        (sleep-for 1.0)
        (while (not (sbt-startup-done))
          (sleep-for 0.1))
        (term-send-raw-string "container:start\n")
        (sleep-for 1.0)
        (while (not (sbt-startup-done))
          (sleep-for 0.1))
        ; and set-up the audition
        (setup-audition)
      )
  ))
;(audition-restart)

(defun audition-compile ()
  (interactive)
  (let ((buf (get-buffer "sbt")))
    (with-current-buffer buf
      (set-buffer buf)
      (evil-insert 1)
      (term-send-raw-string "compile\n")
      (while (not (sbt-startup-done))
        (sleep-for 0.1))
      )))
(audition-compile)


; enclose word in tag
(defun enclose-word-in-tag (tag)
  (interactive "stag:")
  (let (bds p1 p2 inputStr resultStr)

    ;; get boundary
    (if (region-active-p)
        (setq bds (cons (region-beginning) (region-end)))
      (setq bds (bounds-of-thing-at-point 'word)))
    (setq p1 (car bds))
    (setq p2 (cdr bds))

    ;; grab the string
    (setq inputStr (buffer-substring-no-properties p1 p2))
    (setq resultStr (concat "<" tag ">" inputStr "</" tag ">"))
    (delete-region p1 p2)
    (insert resultStr)
    ))

(defun rr ()
  (let ((buf (get-buffer "*ansi-term*")))
    (with-current-buffer buf
      ;(term-down 100)
      (scroll-down)
      )))
(rr)
(defun run-script ()
  (interactive)
  (let ((fil (buffer-file-name))
        (dir default-directory)
        (buf (get-buffer "*ansi-term*")))
    (with-current-buffer buf
      (evil-insert 1)
      (if (not (string-equal dir default-directory))
          (progn
            (term-send-raw-string (concat "cd " dir))
            (term-send-raw-string (kbd "RET"))))
      (term-send-raw-string (concat "python " fil))
      (term-send-raw-string (kbd "RET"))
      (evil-normal-state)
      )))
;(global-set-key (kbd "C-c"))
(evil-ex-define-cmd "R" 'run-script)

(defun scroll-script ()
  (let ((buf (get-buffer "*ansi-term*")))
    (with-current-buffer buf
      (evil-insert 1)
      (term-send-raw-string (kbd "RET"))
      (term-send-raw-string (kbd "RET"))
      (evil-normal-state)
      )))
(scroll-script)

(evil-ex-define-cmd "Rx" 'scroll-script)
