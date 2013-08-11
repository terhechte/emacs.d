(defun create-column (name type)
  (setq tp (split-string name "_"))
  (setq oname (car (cdr tp)))
  (setq vname (if oname oname name))
  (setq vname2 (if oname name (format "ev_%s" name)))
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

(defun another-command ()
  (let ((v (calculate-v))
        (x (calculate-x)))
    (when (and (some-predicate)
               (some other predicate))
      (do-thing-1)
      (do-thing-2)
      (do-thing-3))))
