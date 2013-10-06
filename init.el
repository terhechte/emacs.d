;;                       _                                             _       _ 
;;    ___   ___ ___   __| | ___     ___ _ __ ___   __ _  ___ ___    __| | ___ | |_ 
;;   / _ \ / __/ _ \ / _` |/ _ \   / _ \ '_ ` _ \ / _` |/ __/ __|  / _` |/ _ \| __|
;;  | (_) | (_| (_) | (_| | (_) | |  __/ | | | | | (_| | (__\__ \ | (_| | (_) | |_ 
;;   \___/ \___\___/ \__,_|\___/   \___|_| |_| |_|\__,_|\___|___/  \__,_|\___/ \__|
;;                                          
;; --



;; First a dirty, but cheap way to get .emacs.d subfolders into the load path,
;; and then return us to the user home directory, for find-file etc.
(progn (cd "~/.emacs.d/") (normal-top-level-add-subdirs-to-load-path) (cd "~"))

;(require 'package)
;(add-to-list 'package-archives
;               '("melpa" . "http://melpa.milkbox.net/packages/") t)
;(add-to-list 'package-archives 
;                 '("marmalade" .
;                         "http://marmalade-repo.org/packages/"))
;(package-initialize)

(add-to-list 'default-frame-alist '(font . "M+ 1mn-13"))

;; -- Path -----------------------------------------------------------------------------------------------
;; find XCode and RVM command line tools on OSX (cover the legacy and current XCode directory structures.)
(when (eq system-type 'darwin)
  (when (file-exists-p "/Developer/usr/bin")
    (setq exec-path (append '("/Developer/usr/bin") exec-path)))
  (when (file-exists-p "/Applications/Xcode.app/Contents/Developer/usr/bin")
    (setq exec-path (append '("/Applications/Xcode.app/Contents/Developer/usr/bin") exec-path)))
  (when (file-exists-p "~/.rvm/bin")
    (setq exec-path (append '("~/.rvm/bin") exec-path)))
  (when (file-exists-p "/usr/local/bin/")
    (setq exec-path (append '("/usr/local/bin") exec-path)))
  (when (file-exists-p "/usr/local/share/npm/bin")
    (setq exec-path (append '("/usr/local/share/npm/bin") exec-path))))

(add-to-list 'exec-path "~/bin")

;; turn off toolbar.
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;; menu bar mode only on OS X, just because it's pretty much out of
;; the way, as opposed to sitting right there in the frame.
(if  (and (window-system) (eq system-type 'darwin))
    (menu-bar-mode 1)
  (menu-bar-mode -1)
)

;(setq custom-file "~/.emacs.d/custom/custom.el") ;; Customize stuff goes in custom.el
;(load custom-file)

(setq frame-title-format '("%b %I %+%@%t%Z %m %n %e"))

;; Explicitly require libs that autoload borks
;; Include common lisp:
(require 'cl) ;; one day can remove this...
(require 'cl-lib)
(require 'dash)
(require 's)
(require 'f)
;(require 'iedit)
(require 'ag)
(require 'multiple-cursors)
(require 'js2-refactor)
(require 'helm)
          
;; Modes init (things that need more than just a require.) 
(when (string-match "Emacs 24" (version))
  (message "Running Emacs 24")
  ;; Only run elpa on E24
  (require 'init-elpa)
)

;; -------------------------------------------------------------------------------------------------
;; Additional requires
;; -------------------------------------------------------------------------------------------------
;; Emacs Mac port specific frame adjust
;(require 'mac-frame-adjust)            ;; a few presets for sizing and moving frames (aka OS Windows)

;;; Convenience and completion
(require 'auto-complete-config)        ;; Very nice autocomplete.
(ac-config-default)

(require 'dropdown-list)               ;; dropdown list for use with yasnippet
(require 'switch-window)               ;; Select windows by number.
(require 'resize-window)               ;; interactively size window
(require 'highlight-indentation)       ;; visual guides for indentation
(require 'squeeze-view)                ;; squeeze view, give yourself a write-room/typewriter like writing page
(require 'hexrgb)
(require 'kill-buffer-without-confirm) ;; yes, I really meant to close it.
(require 'scroll-bell-fix)             ;; a small hack to turn off the buffer scroll past top/end bell.
(require 'dabbrev)
(require 'ac-dabbrev)


;; auto-load hyde mode for Jekyll
;(require 'hyde-autoloads) ;; ./vendor/hyde

;; -------------------------------------------------------------------------------------------------
;; Explicit mode inits
;(require 'init-dired)
;(require 'init-hideshowvis)
;(require 'init-multi-web-mode)
;(require 'init-nxml)
;(require 'init-flymake)
;(require 'init-markdown)
;
;; no scrolblars
(scroll-bar-mode -1)

;(setq mweb-default-major-mode 'html-mode)
;(setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
;                  (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
;                                    (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
;                                    (setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
;                                    (multi-web-global-mode 1)

;; conditional - add your own init-marmalade or just login manually
(load-library "marmalade")
;; modes-init/init-marmalade.el is in .gitignore
(when (file-readable-p "modes-init/init-marmalade.el")
  (load-file "modes-init/init-marmalade.el"))

;(require 'handy-functions) ;; my lab area for little defuns...
;(require 'my_functions)

;; Turn on things that auto-load isn't doing for us...
(yas-global-mode t)

;; Autopair alternative
(flex-autopair-mode t)

;; probably all become auto-loaded. (next time)
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

;; AsciiDoc mode
(autoload 'asciidoc-mode "asciidoc-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.asciidoc$" . asciidoc-mode))

;; Rainbow mode for css automatically
(add-hook 'css-mode-hook 'rainbow-mode)

;; Rainbow delimiters for all prog modes
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Git gutter global mode
(add-hook 'prog-mode-hook 'git-gutter-mode)

;; Smoother scrolling (no multiline jumps.)
(setq redisplay-dont-pause t
  scroll-margin 1
  scroll-step 1
  scroll-conservatively 10000
  scroll-preserve-screen-position 1)

;; show paren mode
(show-paren-mode 1)
(setq show-paren-delay 0)

;; use y / n instead of yes / no
(fset 'yes-or-no-p 'y-or-n-p)

;; allow "restricted" features
(put 'set-goal-column           'disabled nil)
(put 'erase-buffer              'disabled nil)
(put 'downcase-region           'disabled nil)
(put 'upcase-region             'disabled nil)
(put 'narrow-to-region          'disabled nil)
(put 'narrow-to-page            'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)


;; Ruby mode filetype hooks ------------------------------------------------------------------------
;; -- this will need migrating to init-ruby-mode.el or sumthin'

(dolist (pattern '("\\.rb$" "^Rakefile$" "\.rake$" "\.rxml$" "\.rjs$" ".irbrc$" "\.builder$" "\.ru$" "\.rabl$" "\.gemspec$" "Gemfile$" "^.pryrc$"))
   (add-to-list 'auto-mode-alist (cons pattern 'ruby-mode)))

(add-hook 'ruby-mode-hook 'flymake-ruby-load)

;; -------------------------------------------------------------------------------------------------
;; Highlight TODO/FIXME/BUG/HACK/REFACTOR & THE HORROR in code - I'm hoping the last one will catch on.
(add-hook 'prog-mode-hook
               (lambda ()
                (font-lock-add-keywords nil
                 '(("\\<\\(NOTE\\|FIXME\\|TODO\\|BUG\\|HACK\\|REFACTOR\\|THE HORROR\\)" 1 font-lock-warning-face t)))))

;; -------------------------------------------------------------------------------------------------
;; use aspell for ispell
(when (file-exists-p "/usr/local/bin/aspell")
  (set-variable 'ispell-program-name "/usr/local/bin/aspell"))

;; -------------------------------------------------------------------------------------------------
;; JavaScript/JSON special files
(dolist (pattern '("\\.jshintrc$" "\\.jslint$"))
  (add-to-list 'auto-mode-alist (cons pattern 'json-mode)))

; javascript
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
;(require 'slime)
;(slime-setup '(slime-js slime-repl slime-scratch))
;(setq slime-js-swank-command "/usr/local/bin/swank-js")
;(setq slime-js-swank-args '())
;(global-set-key [f5] 'slime-js-reload)
;(add-hook 'js2-mode-hook
;          (lambda ()
;            (slime-js-minor-mode 1)))

(require 'simple-httpd)

;; Conditional start of Emacs Server
(setq server-use-tcp t)
(server-start)

; paredit-mode

;; -------------------------------------------------------------------------------------------------

;; Default Font for different window systems
(when (window-system)
 (global-linum-mode 1)
  ;; Mac OS X 
  (when (eq system-type 'darwin)
    ;;(set-face-font 'default "Monaco")
    ;;(set-face-font 'default "Source Code Pro")
    ;(set-face-font 'default "Menlo"))
    ;(set-face-font 'default "M+ 1mn light-13"))
    ;(set-face-font 'default "M+ 1mn light-13"))
    ;;; the real line font font soothe
    ;(add-to-list 'default-frame-alist '(font . "M+ 1mn-13"))
    )
  ;; Sample Text for font viewing 
  '("ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    "abcdefghijklmnopqrstuvwxyz"
    "1234567890!@#$%^&*()-=_+[]\{}|;':<>?,./")
  
  ;; Windows whatever...
  (when (eq system-type 'windows-nt)
    (set-face-font 'default "Consolas")
    )

  ;; GNU Linux (Droid or Vera)
  (when (eq system-type 'gnu/linux)
    (set-face-font 'default "Droid Sans Mono") ;; for quick swapping.
    ;; (set-face-font 'default "Bitstream Vera Sans Mono")
    )
)

;(load-theme 'soothe t)

;(set-face-attribute 'default nil :height 140)

;; -----------------------------------------------------------------------------------------------
;; Custom stuff from me.
;; -----------------------------------------------------------------------------------------------
(require 'powerline)
(powerline-default-theme)
(require 'visual-progress-mode)
(load-theme 'soothe t)

;; No tabs, only 4 spaces, as default
(setq-default indent-tabs-mode nil)
(setq tab-width 4)

;;(set-default-font "SourceCodeProVim3-Regular-15")
;;(set-default-font "mplus-1mn-light-13")
;(set-default-font (:family "M+ 1mn" :foundry "nil" :slant normal :weight light :height 141 :width normal . :height))

;; Kill the welcome buffer
(setq inhibit-startup-message t)

;; Disable splash screen
(setq inhibit-splash-screen t)

;; Highlight current line
(global-hl-line-mode 1)

(setq make-backup-files nil) ; stop creating those backup~ files
(setq auto-save-default nil) ; stop creating those #autosave# files

(recentf-mode 1) ; keep a list of recently opened files


;; Load evil
(setq evil-want-C-u-scroll t)
(setq evil-want-fine-undo t)
(add-to-list 'load-path "~/.emacs.d/elpa/evil-1.0.1")
;(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

;; Load the KeyChord library, to be able to use jj in evil
;;(add-to-list 'load-path "~/.emacs.d/elpa/key-chord-0.5.20080915/")
;;(require 'key-chord)
;;(key-chord-mode 1)
;;(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)

;; New is C-g
(define-key evil-insert-state-map "\C-g" 'evil-normal-state)

;; http://dnquark.com/blog/2012/02/emacs-evil-ecumenicalism/
;; I want c-n / c-p to work like in emacs
(define-key evil-insert-state-map "\C-e" 'end-of-line)
(define-key evil-visual-state-map "\C-e" 'evil-end-of-line)
(define-key evil-normal-state-map "\C-f" 'evil-forward-char)
(define-key evil-insert-state-map "\C-f" 'evil-forward-char)
(define-key evil-insert-state-map "\C-f" 'evil-forward-char)
(define-key evil-normal-state-map "\C-b" 'evil-backward-char)
(define-key evil-insert-state-map "\C-b" 'evil-backward-char)
(define-key evil-visual-state-map "\C-b" 'evil-backward-char)
(define-key evil-normal-state-map "\C-n" 'evil-next-line)
(define-key evil-insert-state-map "\C-n" 'evil-next-line)
(define-key evil-visual-state-map "\C-n" 'evil-next-line)
(define-key evil-normal-state-map "\C-p" 'evil-previous-line)
(define-key evil-insert-state-map "\C-p" 'evil-previous-line)
(define-key evil-visual-state-map "\C-p" 'evil-previous-line)
(define-key evil-normal-state-map "\C-y" 'yank)
(define-key evil-insert-state-map "\C-y" 'yank)
(define-key evil-visual-state-map "\C-y" 'yank)
(define-key evil-normal-state-map "\C-k" 'kill-line)
(define-key evil-insert-state-map "\C-k" 'kill-line)
(define-key evil-visual-state-map "\C-k" 'kill-line)
(define-key evil-normal-state-map (kbd "TAB") 'evil-undefine)

; http://stackoverflow.com/questions/8483182/emacs-evil-mode-best-practice

(defun evil-undefine ()
 (interactive)
 (let (evil-mode-map-alist)
   (call-interactively (key-binding (this-command-keys)))))
 
;(define-key evil-normal-state-map "helm" 'helm-mini)

;;; esc quits
;;;
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

; load evil leader
(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader ",")

(require 'my-functions)
(require 'custom-keys)

;; Run emacs in server mode, so that we can connect from commandline
(server-start)
;; Cycle between the last open buffers
(defun switch-to-previous-buffer ()
      (interactive)
      (switch-to-buffer (other-buffer (current-buffer) 1)))
(define-key evil-normal-state-map "\C-e" 'switch-to-previous-buffer)

(define-key ac-complete-mode-map "\C-n" 'ac-next)
(define-key ac-complete-mode-map "\C-p" 'ac-previous)

;; Support for expand region
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;; paredit docs
; C-j => break and continue
; C-d => forward-delete
; M-d => forward-delete word
; M-DEL => backwards delete word
; M-<Up> => splice sexp killing backward (remove sexp before cursor)
; M-<Down> => splice sexp killing forward (remove sexp before cursor)
; M-r => raise sexp, some weird stuff that moves the current sexp up
; C-) => (use caps lock + shift + 0) move the next sexp into the current one. cursor is *in* the current expression
; C-} => move the next sexp away from the current one
; C-( => (use caps lock + shift + 9) move the previous sexp into the current one. cursor is *in* the current expression
; C-{ => move the previous sexp away from the current one

;; http://stackoverflow.com/questions/6344474/how-can-i-make-emacs-highlight-lines-that-go-over-80-chars
;; free of trailing whitespace and to use 80-column width, standard indentation
(setq whitespace-style '(trailing lines space-before-tab
                                  indentation space-after-tab)
      whitespace-line-column 80)


;; Scala mode
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

;; Set backup directory location
(setq backup-directory-alist '(("." . "~/.emacs.d/saves/")))

;; Make backups by copying
(setq backup-by-copying-when-linked t)

(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)


;; Use spaces instead of tabs for indentation
(setq indent-tabs-mode nil)

;; yes-or-no => y-or-n
(fset 'yes-or-no-p 'y-or-n-p)

;; flycheck
(require 'flycheck)

;; jedi
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:setup-keys t)                      ; optional
(setq jedi:complete-on-dot t)                 ; optional

;; Switching to relative number
(defun relativenumber
  ()
  (interactive)
  (require 'relative-number))
(relativenumber)

(defun yce-setup ()
  (interactive)
  (auto-complete-mode 1)
  (require 'youcompletemacs))
     
;; You Complete mEmacs
(require 'youcompletemacs)
(add-to-list 'ac-modes 'objc-mode)
(add-hook 'objc-mode-hook (lambda ()
          (message "objc mode hook")
          (auto-complete-mode 1)
          (yce-config)))


; Irony Mode trying
;(add-to-list 'load-path (expand-file-name "~/.emacs.d/irony-mode/elisp/"))
;(require 'auto-complete)
;(require 'irony)
;(irony-enable 'ac)
;(add-hook 'c++-mode-hook 'irony-mode)
;(add-hook 'c-mode-hook 'irony-mode)
;(add-hook 'objc-mode-hook 'irony-mode)

;; old-school fullscreen-mode
(defun toggle-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
    nil 'fullscreen
    (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

;; After startup, show the recent open files
(recentf-open-files)

(helm-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("c377a5f3548df908d58364ec7a0ee401ee7235e5e475c86952dc8ed7c4345d8e" default)))
 '(httpd-port 8187)
 '(send-mail-function (quote mailclient-send-it)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

 ; set different linum color
; and cua mode for copy / paste
(cua-mode)
;(set-face-attribute 'linum nil :foreground "#999")
;(set-face-attribute 'region nil :foreground "#233a51" :background "#99b8d7")

;(set-face-attribute 'region nil :foreground nil :background "#243339")
(setq evil-default-cursor t)
(set-cursor-color "#ffffff")

;zencoding:
;<C-j>
;lisp:
;C-x C-e

;(require 'face-remap)
;(require 'color-theme-buffer-local)
;(defvar highlight-focus:last-buffer nil)
;(defvar highlight-focus:cookie nil)
;(defvar highlight-focus:focus-theme 'soothe)
;(defvar highlight-focus:unfocus-theme 'subatomic256)

;(defun highlight-focus:check ()
;  "Check if focus has changed, and if so, update remapping."
;  (unless (eq highlight-focus:last-buffer (current-buffer))
;    (when (and highlight-focus:last-buffer highlight-focus:cookie)
;      (with-current-buffer highlight-focus:last-buffer
;        (load-theme-buffer-local highlight-focus:unfocus-theme highlight-focus:last-buffer)))
;    (setq highlight-focus:last-buffer (current-buffer)
;          highlight-focus:cookie t)
;    (load-theme-buffer-local highlight-focus:focus-theme (current-buffer))))
;    
;(defadvice other-window (after highlight-focus activate)
;  (highlight-focus:check))
;(defadvice select-window (after highlight-focus activate)
;  (highlight-focus:check))
;(defadvice select-frame (after highlight-focus activate)
;  (highlight-focus:check))
;(add-hook 'window-configuration-change-hook 'highlight-focus:check)
;
;(provide 'highlight-focus)

; Setting up Multi-Cursor Mode
; New-line in multi-cursor-mode = C-j

; https://github.com/magnars/multiple-cursors.el/issues/19
; Now multiple-cursor-mode (entering it) will go into emacs mode
; so that all the emacs bindings work
(defvar my-mc-evil-previous-state nil)

(defun my-mc-evil-switch-to-insert-state ()
  (when (and (bound-and-true-p evil-mode)
             (not (memq evil-state '(insert emacs))))
    (setq my-mc-evil-previous-state evil-state)
    (evil-emacs-state 1)))

(defun my-mc-evil-back-to-previous-state ()
  (when my-mc-evil-previous-state
    (unwind-protect
        (case my-mc-evil-previous-state
          ((normal visual) (evil-force-normal-state))
          (t (message "Don't know how to handle previous state: %S"
                      my-mc-evil-previous-state)))
      (setq my-mc-evil-previous-state nil))))

(add-hook 'multiple-cursors-mode-enabled-hook
          'my-mc-evil-switch-to-insert-state)
(add-hook 'multiple-cursors-mode-disabled-hook
          'my-mc-evil-back-to-previous-state)

(defun my-rrm-evil-switch-state ()
  (if rectangular-region-mode
      (my-mc-evil-switch-to-insert-state)
    ;; (my-mc-evil-back-to-previous-state)  ; does not work...
    (setq my-mc-evil-previous-state nil)))

(add-hook 'rectangular-region-mode-hook 'my-rrm-evil-switch-state)

; http://paralambda.org/2012/07/02/using-gnu-emacs-as-a-terminal-emulator/
; https://github.com/jstautz/.emacs.d/blob/master/config/init-multi-term.el
(when (require 'term nil t) ; only if term can be loaded..
  (setq term-bind-key-alist
        (list (cons "C-c C-c" 'term-interrupt-subjob)
              (cons "C-p" 'previous-line)
              (cons "C-n" 'next-line)
              (cons "M-f" 'term-send-forward-word)
              (cons "M-b" 'term-send-backward-word)
              (cons "C-c C-j" 'term-line-mode)
              (cons "C-c C-k" 'term-char-mode)
              (cons "M-DEL" 'term-send-backward-kill-word)
              (cons "M-d" 'term-send-forward-kill-word)
              (cons "<C-left>" 'term-send-backward-word)
              (cons "<C-right>" 'term-send-forward-word)
              (cons "<tab>" 'term-dynamic-complete)
              (cons "C-r" 'term-send-reverse-search-history)
              (cons "M-p" 'term-send-raw-meta)
              (cons "M-y" 'term-send-raw-meta)
              (cons "C-y" 'term-send-raw))))

(when (require 'term nil t)
  (defun term-handle-ansi-terminal-messages (message)
    (while (string-match "\eAnSiT.+\n" message)
      ;; Extract the command code and the argument.
      (let* ((start (match-beginning 0))
             (command-code (aref message (+ start 6)))
             (argument
              (save-match-data
                (substring message
                           (+ start 8)
                           (string-match "\r?\n" message
                                         (+ start 8))))))
        ;; Delete this command from MESSAGE.
        (setq message (replace-match "" t t message))
 
        (cond ((= command-code ?c)
               (setq term-ansi-at-dir argument))
              ((= command-code ?h)
               (setq term-ansi-at-host argument))
              ((= command-code ?u)
               (setq term-ansi-at-user argument))
              ((= command-code ?e)
               (save-excursion
                 (find-file-other-window argument)))
              ((= command-code ?x)
               (save-excursion
                 (find-file argument))))))
 
    (when (and term-ansi-at-host term-ansi-at-dir term-ansi-at-user)
      (setq buffer-file-name
            (format "%s@%s:%s" term-ansi-at-user term-ansi-at-host term-ansi-at-dir))
      (set-buffer-modified-p nil)
        (setq default-directory (if (string= term-ansi-at-host (system-name))
                                    (concatenate 'string term-ansi-at-dir "/")
                                  (format "/%s@%s:%s/" term-ansi-at-user term-ansi-at-host term-ansi-at-dir))))
    message))

(when (require 'multi-term nil t)
  (global-set-key (kbd "<f5>") 'multi-term)
  (global-set-key (kbd "<s-next>") 'multi-term-next)
  (global-set-key (kbd "<s-prior>") 'multi-term-prev)
  (setq multi-term-scroll-to-bottom-on-output t)
  (setq multi-term-buffer-name "ansi-term"
        multi-term-program "/bin/zsh"))

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines) ; edit multicursors on all selected lines
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click) ; edit multicursors on mouse positions
(global-set-key (kbd "C->") 'mc/mark-next-like-this) ; multiple cursors on next word like this
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this) ; on previous
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;(global-set-key (kbd "C-x v") 'eval-region)
(define-key evil-normal-state-map (kbd "C-.") 'execute-extended-command)
(define-key evil-visual-state-map (kbd "C-.") 'execute-extended-command)

; http://stackoverflow.com/questions/683425/globally-override-key-binding-in-emacs
(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")

(define-key my-keys-minor-mode-map (kbd "C-.") 'execute-extended-command)

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t " my-keys" 'my-keys-minor-mode-map)

(my-keys-minor-mode 1)

; do not do this in minibuffer
(defun my-minibuffer-setup-hook ()
  (my-keys-minor-mode 0))

(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)

(require 'ace-jump-mode)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

; Simple clip makes it possible to not overwrite clipboard during yanking
; https://github.com/rolandwalker/simpleclip
(require 'simpleclip)
(simpleclip-mode 1)

; add s-n for opening a new window
(global-set-key (kbd "s-n") 'new-frame)

; Setup mail in emacs

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

;; less linum width

; my task mode
(require 'task-mode)
; and set up leaders for it
(evil-leader/set-key-for-mode 'task-mode "d" 'task-mode-todo-task)


; a simple function that generates a new random buffer,
; so that I can easily create a scratch buffer
(defvar new-buffer-counter 0 "the counter where the new new-buffer tracks the buf number")
(defun new-buffer ()
  (interactive)
  (let ((new-buffer-name (format "new-buffer-%i" new-buffer-counter)))
    (get-buffer-create new-buffer-name)
    (setq new-buffer-counter (+ 1 new-buffer-counter))
    (switch-to-buffer new-buffer-name)))
(evil-leader/set-key "n" 'new-buffer)

; this should make always abbrev everything, not working though yet
;(defun start-auto-complete ()
;  (interactive)
;  (require 'auto-complete)
;  (global-auto-complete-mode t)
;  (define-key ac-complete-mode-map "\C-n" 'ac-next)
;  (define-key ac-complete-mode-map "\C-p" 'ac-previous)
;  (setq ac-auto-start 3)
;  (define-key ac-complete-mode-map "\M-/" 'ac-stop)
;  )


; Docs:
; helm-do-grep for fast grep in current diredtory and what not !
; try to use Capslock as Control wherever possible
; C-. is my new m-x
; 
; C-` is the mode where each buffer shows a number
; C-c SPC -> ace jump mode
; C-u C-u C-c SPC” ⇒ ace-jump-line-mode

; Org-mode


; TODO Emacs:
; - das  terminal wenn am rand, wackelt so schlimm
; - die markierte zeile verliert das syntax coloring, obwohl sich nur der bg aendert @done
; - org mode doku downloaden und irgendwo hinterlegen
; - die init.el aufsplitten in einzelene dateien in custom/ die ich dann lade
; - den simple task mode bei github hinterlegen und dann ueber elpa laden
; - completion im terminal tuts noch immer nicht
; - die status bar anders aussehen lassen, texte etwas groesser, dunklere hintergruende, focus anders machen als der rahmen @done
; - den font frueher im startup laden
