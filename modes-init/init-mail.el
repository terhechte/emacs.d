(setq user-full-name "Benedikt Terhechte")
(setq user-mail-address "terhechte@gmail.com")
(setq starttls-use-gnutls t)
(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials '(("smtp.gmail.com" 587
                   "terhechte@gmail.com" nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")
(require 'smtpmail)
;;; Set some sane defaults for VM's replies and forwarding
;;;
(setq
vm-forwarding-subject-format "[forwarded from %F] %s"
vm-forwarding-digest-type "rfc934"
vm-in-reply-to-format nil
vm-included-text-attribution-format
"On %w, %m %d, %y at %h (%z), %F wrote:n"
vm-reply-subject-prefix "Re: "
vm-mail-header-from "Benedikt Terhechte <terhechte@gmail.com>"
)

(provide 'init-mail)