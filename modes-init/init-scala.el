
(require 'package)
(unless (package-installed-p 'scala-mode2)
  (package-refresh-contents) (package-install 'scala-mode2))

;; Ensime
(add-to-list 'load-path "~/.emacs.d/ensime/elisp/")
(require 'ensime)

;; This step causes the ensime-mode to be started whenever
;; scala-mode is started for a buffer. You may have to customize this step
;; if you're not using the standard scala mode.
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

;; Show errors after saving
(add-hook 'ensime-source-buffer-saved-hook 
                    'ensime-show-all-errors-and-warnings)

(push "/usr/local/bin/" exec-path)

;; Run Scala
(defun scala-run () 
  (interactive)   
  (ensime-sbt-action "run")
  (ensime-sbt-action "~compile")
  (let ((c (current-buffer)))
    (switch-to-buffer-other-window
      (get-buffer-create (ensime-sbt-build-buffer-name)))
    (switch-to-buffer-other-window c))) 
(setq exec-path
      (append exec-path (list "/usr/local/bin/"))) 

(provide 'init-scala)
