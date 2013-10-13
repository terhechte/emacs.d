;; make sp-select-next-thing works even the cusor is in the open/close tag
;; like matchit in vim
;; @return t => start from open tag; nil start from close tag
(defun my-sp-select-next-thing (&optional NUM)
  (interactive "p")
  (let ((b (line-beginning-position))
        (e (line-end-position))
        (char (following-char))
        (p (point))
        rbeg
        rend
        (rlt t)
        )
    ;; "<" char code is 60
    ;; search backward
    (if (not (= char 60))
        (save-excursion
          (while (and (<= b (point)) (not (= char 60)))
            (setq char (following-char))
            (setq p (point))
            (backward-char)
            )
          )
      )
    ;; search forward
    (if (not (= char 60))
        (save-excursion
          (while (and (>= e (point)) (not (= char 60)))
            (setq char (following-char))
            (setq p (point))
            (forward-char)
            )
          )
      )
    ;; do the real thing
    (when (and (= char 60) (< p e))
      (goto-char p)
      (forward-char)
      (if (= (following-char) 47)
          (progn
            ;; </
            (backward-char)
            (setq rlt nil)
            )
        (progn
          ;; < , looks fine
          (backward-char)
          (setq rlt t)
          )
        )
      (sp-select-next-thing)
      (setq rbeg (region-beginning))
      (setq rend (region-end))
 
      (while (> NUM 1)
        ;; well, sp-select-next-thing is kind of wierd
        (re-search-forward "<[^!]")
        (backward-char 2)
        (sp-select-next-thing)
        (setq rend (region-end))
        (setq NUM (1- NUM))
        )
      (push-mark rbeg t t)
      (goto-char (1- rend))
      )
    rlt
    )
  )

(provide 'matchit)
