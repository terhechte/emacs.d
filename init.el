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
(require 'custom-keys)

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
    (add-to-list 'default-frame-alist '(font . "M+ 1mn-13")))
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

(set-face-attribute 'default nil :height 140)

;; -----------------------------------------------------------------------------------------------
;; Custom stuff from me.
;; -----------------------------------------------------------------------------------------------

;; No tabs, only 4 spaces, as default
(setq-default indent-tabs-mode nil)
(setq tab-width 4)

;;(set-default-font "SourceCodeProVim3-Regular-15")
;;(set-default-font "mplus-1mn-light-13")
;;(set-default-font (:family "M+ 1mn" :foundry "nil" :slant normal :weight light :height 141 :width normal . :height))

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
(defun evil-undefine ()
 (interactive)
 (let (evil-mode-map-alist)
   (call-interactively (key-binding (this-command-keys)))))

(define-key evil-insert-state-map "\C-n" 'evil-undefine)
(define-key evil-insert-state-map "\C-p" 'evil-undefine)

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

;; Run emacs in server mode, so that we can connect from commandline
(server-start)
;; Cycle between the last open buffers
(defun switch-to-previous-buffer ()
      (interactive)
      (switch-to-buffer (other-buffer (current-buffer) 1)))
(define-key evil-normal-state-map "\C-e" 'switch-to-previous-buffer)

(define-key ac-complete-mode-map "\C-n" 'ac-next)
(define-key ac-complete-mode-map "\C-p" 'ac-previous)

; http://www.emacswiki.org/emacs/GenericMode
; Try adding my own minor mode for taskpaper, that really just offers syntax highlighting
(require 'generic-x)
(define-generic-mode
    'task-mode ;name of the mode
  '("---") ;how comments are defined in mode
  '("@done" "@later" "@testing" "@important" "@non-happen") ;keywords
  nil ;operators
  '("\\.txt$", "\\.taskpaper$", "\\.todo$", "\\.tasks$") ;filenames to activate this mode for
  (list (lambda () (highlight-lines-matching-regexp "\\@done" "hi-green-b")) ;my line colors
        (lambda () (highlight-lines-matching-regexp "\\@later" "hi-blue-b"))
        (lambda () (highlight-lines-matching-regexp "\\@testing" "hi-yellow-b"))
        (lambda () (highlight-lines-matching-regexp "\\@important" "hi-red-b"))
        (lambda () (highlight-lines-matching-regexp "\\@non-happen" "hi-gray-b")))
  "A mode for task files")
  
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

;; less linum width
(setq linum-format "%3d")

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

;(defun yce-setup ()
;  (interactive)
;  (auto-complete-mode 1)
;  (require 'youcompletemacs))
     
;; You Complete mEmacs
(require 'youcompletemacs)
(add-to-list 'ac-modes 'objc-mode)
(add-hook 'objc-mode-hook (lambda ()
          (message "objc mode hook")
          (auto-complete-mode 1)
          (yce-config)))

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
 '(custom-safe-themes (quote ("c377a5f3548df908d58364ec7a0ee401ee7235e5e475c86952dc8ed7c4345d8e" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

 ; set different linum color
; and cua mode for copy / paste
(cua-mode)
(set-face-attribute 'linum nil :foreground "#999")
(set-face-attribute 'region nil :foreground "#233a51" :background "#99b8d7")
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

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines) ; edit multicursors on all selected lines
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click) ; edit multicursors on mouse positions
(global-set-key (kbd "C->") 'mc/mark-next-like-this) ; multiple cursors on next word like this
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this) ; on previous
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(global-set-key (kbd "C-x v") 'eval-region)

; Docs:
; helm-do-grep for fast grep in current diredtory and what not !
