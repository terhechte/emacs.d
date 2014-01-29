
(defun get-mail-data (from-buffer-name)
  "Return a dictionary/hash/map from the data buffer with the keys
   name, surname, site and email set."
  (pairlis '("name" "surname" "site" "email")
           (split-string-and-unquote
            (with-current-buffer (get-buffer from-buffer-name)
              (buffer-substring-no-properties (line-beginning-position)
                                              (line-end-position))))))

(defun get-template-data (from-template-buffer)
  "Return the mail template from the template buffer as a string"
  (with-current-buffer (get-buffer from-template-buffer) (buffer-string)))

(defun personalize (subject)
  "Send personalized mails. Each call of the func"
  (interactive "M\nEnter Mail Subject: ")

  (let* ((text "template")
         (dict (get-mail-data "data.el")))

    (loop for (key . value) in dict do
          (setq text (replace-regexp-in-string (format "\\[%s\\]" key) value text)))

    (kill-new text)

    (with-current-buffer (get-buffer "data.el") (forward-line))
    (compose-mail (cdr (assoc "email" dict)) subject)))

(global-set-key (kbd "C-x 9") 'personalize)

