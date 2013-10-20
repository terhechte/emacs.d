
;;; ob-objc.el --- org-babel functions for Objective-C languages

;; Copyright (C) 2010  Free Software Foundation, Inc.

;; Author: Kentarou Shimatani
;; Keywords: literate programming, reproducible research
;; Homepage: http://orgmode.org
;; Version: 7.01h

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Org-Babel support for evaluating Objective-C code.
;;
;; very limited implementation:
;; - currently only support :results output
;; - not much in the way of error feedback

;;; Code:
(eval-when-compile (require 'cl))
(require 'ob-C)

(declare-function org-entry-get "org"
                  (pom property &optional inherit literal-nil))

(add-to-list 'org-babel-tangle-lang-exts '("objc" . "m"))

(defvar org-babel-default-header-args:objc '())

(defvar org-babel-objc-compiler "gcc -framework Foundation"
  "Command used to compile a objective-C source code file into an
  executable.")

(defun org-babel-execute:objc (body params)
    "Execute a block of objc code with org-babel.  This function is
called by `org-babel-execute-src-block'."
  (let ((org-babel-c-variant 'objc)) (org-babel-C-execute body params)))

(defun org-babel-expand-body:objc (body params &optional processed-params)
  "Expand a block of objc code with org-babel according to it's
header arguments (calls `org-babel-C-expand')."
  (let ((org-babel-c-variant 'objc)) (org-babel-C-expand body params processed-params)))

(defun org-babel-C-execute (body params)
  "This function should only be called by `org-babel-execute:C'
or `org-babel-execute:c++'."
  (let* ((processed-params (org-babel-process-params params))
         (tmp-src-file (make-temp-file "org-babel-C-src" nil
                                       (case org-babel-c-variant
                                        (c ".c")
                                        (objc ".m")
                                        (cpp ".cpp"))))
         (tmp-bin-file (make-temp-file "org-babel-C-bin"))
         (tmp-out-file (make-temp-file "org-babel-C-out"))
         (cmdline (cdr (assoc :cmdline params)))
         (flags (cdr (assoc :flags params)))
         (full-body (org-babel-C-expand body params))
         (compile
          (progn
            (with-temp-file tmp-src-file (insert full-body))
            (org-babel-eval
             (format "%s -o %s %s %s"
                     (case org-babel-c-variant
                      (c org-babel-C-compiler)
                      (objc org-babel-objc-compiler)
                      (cpp org-babel-c++-compiler))
                     tmp-bin-file
                     (mapconcat 'identity
                                (if (listp flags) flags (list flags)) " ")
                     tmp-src-file) ""))))
    ((lambda (results)
       (org-babel-reassemble-table
        (if (member "vector" (nth 2 processed-params))
            (let ((tmp-file (make-temp-file "ob-c")))
              (with-temp-file tmp-file (insert results))
              (org-babel-import-elisp-from-file tmp-file))
          (org-babel-read results))
        (org-babel-pick-name
         (nth 4 processed-params) (cdr (assoc :colnames params)))
        (org-babel-pick-name
         (nth 5 processed-params) (cdr (assoc :rownames params)))))
     (org-babel-trim
       (org-babel-eval
        (concat tmp-bin-file (if cmdline (concat " " cmdline) "")) "")))))

(defun org-babel-C-expand (body params &optional processed-params)
  "Expand a block of C or C++ or Objective-Ccode with org-babel according to
it's header arguments."
  (let ((vars (nth 1 (or processed-params
                          (org-babel-process-params params))))
        (main-p (not (string= (cdr (assoc :main params)) "no")))
        (includes (or (cdr (assoc :includes params))
                      (org-babel-read (org-entry-get nil "includes" t))))
        (imports (or (cdr (assoc :imports params))
                      (org-babel-read (org-entry-get nil "imports" t))))
        (defines (org-babel-read
                  (or (cdr (assoc :defines params))
                      (org-babel-read (org-entry-get nil "defines" t))))))
    (org-babel-trim
     (mapconcat 'identity
                (list
                 ;; includes
                 (mapconcat
                  (lambda (inc) (format "#include %s" inc))
                  (if (listp includes) includes (list includes)) "\n")
                 ;; imports
                 (mapconcat
                  (lambda (inc) (format "#import %s" inc))
                  (if (listp imports) imports (split-string imports)) "\n")
                 ;; defines
                 (mapconcat
                  (lambda (inc) (format "#define %s" inc))
                  (if (listp defines) defines (list defines)) "\n")
                 ;; variables
                 (mapconcat 'org-babel-C-var-to-C vars "\n")
                 ;; body
                 (if main-p
                     (org-babel-C-ensure-main-wrap body)
                   body) "\n") "\n"))))

(provide 'ob-objc)

;; arch-tag: 8f49e462-54e3-417b-9a8d-423864893b37

;;; ob-C.el ends here
