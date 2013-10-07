;; First a dirty, but cheap way to get .emacs.d subfolders into the load path,
;; and then return us to the user home directory, for find-file etc.
(progn (cd "~/.emacs.d/") (normal-top-level-add-subdirs-to-load-path) (cd "~"))

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

(setq frame-title-format '("%b %I %+%@%t%Z %m %n %e"))

;; Explicitly require libs that autoload borks
;; Include common lisp:
(require 'cl) ;; one day can remove this...
(require 'cl-lib)
(require 'dash)
(require 's)
(require 'f)
(require 'ag)
(require 'multiple-cursors)
(require 'js2-refactor)
(require 'helm)

;; Modes init (things that need more than just a require.) 
(when (string-match "Emacs 24" (version))
  ;; Only run elpa on E24
  (require 'init-elpa)
)

;; -------------------------------------------------------------------------------------------------
;; Additional requires
;; -------------------------------------------------------------------------------------------------
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

;; no scrolblars
(scroll-bar-mode -1)

;; conditional - add your own init-marmalade or just login manually
(load-library "marmalade")
(when (file-readable-p "modes-init/init-marmalade.el")
  (load-file "modes-init/init-marmalade.el"))

;; Turn on things that auto-load isn't doing for us...
(yas-global-mode t)

;; Autopair alternative
(flex-autopair-mode t)

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

(require 'simple-httpd)

;; Conditional start of Emacs Server
(setq server-use-tcp t)
(server-start)

;; -------------------------------------------------------------------------------------------------

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

;; Kill the welcome buffer
(setq inhibit-startup-message t)

;; Disable splash screen
(setq inhibit-splash-screen t)

;; Highlight current line
(global-hl-line-mode 1)

;; Highlight indent, for python
(require 'highlight-indentation)
(add-hook 'python-mode-hook 'highlight-indentation-mode)

(setq make-backup-files nil) ; stop creating those backup~ files
(setq auto-save-default nil) ; stop creating those #autosave# files

(recentf-mode 1) ; keep a list of recently opened files


;; Load evil
(require 'init-evil)

(evil-leader/set-key "n" 'new-buffer)

(evil-leader/set-key "t" 'switch-to-previous-buffer)

(evil-leader/set-key "re" 'recentf-open-files)
(evil-leader/set-key "rl" 'revert-buffer)

(evil-leader/set-key "l" 'buffer-list-in-window)

(evil-leader/set-key "c" 'delete-window)

(require 'my-functions)

(require 'custom-keys)

;; Run emacs in server mode, so that we can connect from commandline
(server-start)

(define-key ac-complete-mode-map "\C-n" 'ac-next)
(define-key ac-complete-mode-map "\C-p" 'ac-previous)

;; Support for expand region
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)


;; http://stackoverflow.com/questions/6344474/how-can-i-make-emacs-highlight-lines-that-go-over-80-chars
;; free of trailing whitespace and to use 80-column width, standard indentation
(setq whitespace-style '(trailing lines space-before-tab
                                  indentation space-after-tab)
      whitespace-line-column 80)


;; Scala mode
(require 'init-scala)

(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; flycheck
(require 'flycheck)

;; jedi
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:setup-keys t)                      ; optional
(setq jedi:complete-on-dot t)                 ; optional

;; Switching to relative number
(global-linum-mode 1)
(require 'relative-number)



;; After startup, show the recent open files
(recentf-open-files)

(helm-mode 1)

(require 'init-hideshowvis)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("c377a5f3548df908d58364ec7a0ee401ee7235e5e475c86952dc8ed7c4345d8e" default)))
 '(httpd-port 8187)
 '(send-mail-function (quote mailclient-send-it)))

 ; set different linum color
; and cua mode for copy / paste
(cua-mode)

(setq evil-default-cursor t)
(set-cursor-color "#ffffff")

; Terminal
(require 'init-term)

; Multicursor
(require 'init-multicursor)

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
(require 'init-mail)

; my task mode
(require 'task-mode)
; and set up leaders for it
(evil-leader/set-key-for-mode 'task-mode "d" 'task-mode-todo-task)
(evil-leader/set-key-for-mode 'task-mode "a" 'task-mode-archive-done)
(evil-leader/set-key-for-mode 'task-mode "c" 'task-mode-new-todo)



; TODO Emacs:
; - das  terminal wenn am rand, wackelt so schlimm
; - org mode doku downloaden und irgendwo hinterlegen
; - den simple task mode bei github hinterlegen und dann ueber elpa laden
; - completion im terminal tuts noch immer nicht
; - get objective-c completion working
; - better CSS completion
; - better python mode, still sucks a bit
; - full word autocompletion like in vim please
