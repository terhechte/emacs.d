;;                       _                                             _       _ 
;;    ___   ___ ___   __| | ___     ___ _ __ ___   __ _  ___ ___    __| | ___ | |_ 
;;   / _ \ / __/ _ \ / _` |/ _ \   / _ \ '_ ` _ \ / _` |/ __/ __|  / _` |/ _ \| __|
;;  | (_) | (_| (_) | (_| | (_) | |  __/ | | | | | (_| | (__\__ \ | (_| | (_) | |_ 
;;   \___/ \___\___/ \__,_|\___/   \___|_| |_| |_|\__,_|\___|___/  \__,_|\___/ \__|
;;                                          
;; dirty, but cheap way to get .emacs.d subfolders into the load path,
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

(setq custom-file "~/.emacs.d/custom/custom.el") ;; Customize stuff goes in custom.el
(load custom-file)
(require 'custom-keys)

(setq frame-title-format '("%b %I %+%@%t%Z %m %n %e"))

;; Explicitly require libs that autoload borks
;; Include common lisp
(require 'cl) ;; one day can remove this...
(require 'cl-lib)
(require 'dash)
(require 's)
(require 'iedit)
(require 'ag)

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
(require 'mac-frame-adjust)            ;; a few presets for sizing and moving frames (aka OS Windows)

;;;# Convenience and completion
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

;; auto-load hyde mode for Jekyll
(require 'hyde-autoloads) ;; ./vendor/hyde

;; (require 'w3m)

;; --- Main-line only on window systems ----- (a fork of Powerline
(when (window-system)
  (require 'main-line)
  (setq main-line-separator-style 'wave))

;; -------------------------------------------------------------------------------------------------
;; Explicit mode inits
(require 'init-dired)
(require 'init-hideshowvis)
(require 'init-multi-web-mode)
(require 'init-nxml)
(require 'init-flymake)
(require 'init-markdown)

;; conditional - add your own init-marmalade or just login manually
(load-library "marmalade")
;; modes-init/init-marmalade.el is in .gitignore
(when (file-readable-p "modes-init/init-marmalade.el")
  (load-file "modes-init/init-marmalade.el"))

(require 'handy-functions) ;; my lab area for little defuns...

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

(dolist (pattern '("\\.rb$" "Rakefile$" "\.rake$" "\.rxml$" "\.rjs$" ".irbrc$" "\.builder$" "\.ru$" "\.rabl$" "\.gemspec$" "Gemfile$"))
   (add-to-list 'auto-mode-alist (cons pattern 'ruby-mode)))

(add-hook 'ruby-mode-hook 'flymake-ruby-load)

;; -------------------------------------------------------------------------------------------------
;; Highlight TODO/FIXME/BUG/HACK/REFACTOR & THE HORROR in code - I'm hoping the last one will catch on.
(add-hook 'prog-mode-hook
               (lambda ()
                (font-lock-add-keywords nil
                 '(("\\<\\(NOTE\\|FIXME\\|TODO\\|BUG\\|HACK\\|REFACTOR\\|THE HORROR\\):" 1 font-lock-warning-face t)))))

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
(when (and (fboundp 'server-running-p) (not (server-running-p))) (server-start))

;; Default Font for different window systems
(when (window-system)
 (global-linum-mode 1)
  ;; Mac OS X 
  (when (eq system-type 'darwin)
    ;;(set-face-font 'default "Monaco")
    ;;(set-face-font 'default "Source Code Pro")
    (set-face-font 'default "Menlo"))
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

;; Custom themes added to load-path
(-each
 (-map
  (lambda (item)
    (format "~/.emacs.d/elpa/%s" item))
  (-filter
   (lambda (item) (s-contains? "theme" item))
   (directory-files "~/.emacs.d/elpa/")))
 (lambda (item)
   (add-to-list 'custom-theme-load-path item)))

(load-theme 'soothe)

(set-face-attribute 'default nil :height 140)

;; -----------------------------------------------------------------------------------------------
;; Custom stuff from me.
;; -----------------------------------------------------------------------------------------------

;; No tabs, only 4 spaces, as default
(setq-default indent-tabs-mode nil)
(setq tab-width 4)

;(set-default-font "SourceCodeProVim3-Regular-15")
;(set-default-font "M+ 1mn light-13")
(set-default-font "mplus-1mn-light-13")

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
(add-to-list 'load-path "~/.emacs.d/elpa/key-chord-0.5.20080915/")
(require 'key-chord)
(key-chord-mode 1)

;; http://dnquark.com/blog/2012/02/emacs-evil-ecumenicalism/
;; I want c-n / c-p to work like in emacs
(defun evil-undefine ()
 (interactive)
 (let (evil-mode-map-alist)
   (call-interactively (key-binding (this-command-keys)))))

(define-key evil-insert-state-map "\C-n" 'evil-undefine)
(define-key evil-insert-state-map "\C-p" 'evil-undefine)

(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)

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

;; After startup, show the recent open files
(recentf-open-files)
