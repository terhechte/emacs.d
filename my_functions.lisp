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
  (interactive)
  (url-retrieve url
                (lambda (status) (switch-to-buffer (current-buffer)))))

(require 'request)
(defun get-msg-url (url)
  (interactive)
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

