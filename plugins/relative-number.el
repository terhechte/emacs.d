(defvar my-linum-format-string "%5d")

(add-hook 'linum-before-numbering-hook 'my-linum-get-format-string)

(defun my-linum-get-format-string ()
  ; The + 2 defines the leeway we have in the sidebar
  (let* ((width (+ 2 (length (number-to-string
                             (count-lines (point-min) (point-max))))))
         (format (concat "%" (number-to-string width) "d")))
    (setq my-linum-format-string format)))

(defvar my-linum-current-line-number 0)

(setq linum-format 'my-linum-relative-line-numbers)

;(propertize (format my-linum-format-string noffset) 'face 'linum)
(defun my-linum-relative-line-numbers (line-number)
    (let ((offset (- line-number my-linum-current-line-number)))
      (if (= offset 0)
          (propertize (format my-linum-format-string line-number) 'face 'linum)
          (propertize (format my-linum-format-string (abs offset)) 'face 'linum))))

(defadvice linum-update (around my-linum-update)
             (let ((my-linum-current-line-number (line-number-at-pos)))
                   ad-do-it))
(ad-activate 'linum-update)

(provide 'relative-number)
