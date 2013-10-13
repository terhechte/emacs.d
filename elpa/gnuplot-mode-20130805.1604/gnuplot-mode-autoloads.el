;;; gnuplot-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (gnuplot-run-buffer gnuplot-run-region gnuplot-compile
;;;;;;  gnuplot-mode) "gnuplot-mode" "gnuplot-mode.el" (21082 42652
;;;;;;  0 0))
;;; Generated autoloads from gnuplot-mode.el

(autoload 'gnuplot-mode "gnuplot-mode" "\
Major mode for editing gnuplot files

\(fn)" t nil)

(dolist (pattern '("\\.gnuplot\\'" "\\.gp\\'")) (add-to-list 'auto-mode-alist (cons pattern 'gnuplot-mode)))

(autoload 'gnuplot-compile "gnuplot-mode" "\
Runs gnuplot -persist as a synchronous process and passes the
current buffer to it.  Buffer must be visiting a file for it to
work.

\(fn)" t nil)

(autoload 'gnuplot-run-region "gnuplot-mode" "\
Send region to gnuplot, ensuring a final newline.  Doesn't
require buffer to be visiting a file.

\(fn START END)" t nil)

(autoload 'gnuplot-run-buffer "gnuplot-mode" "\
Send buffer to gnuplot, ensuring a final newline.  Doesn't
require buffer to be visiting a file.

\(fn)" t nil)

;;;***

;;;### (autoloads nil nil ("gnuplot-mode-pkg.el") (21082 42652 918614
;;;;;;  0))

;;;***

(provide 'gnuplot-mode-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; gnuplot-mode-autoloads.el ends here
