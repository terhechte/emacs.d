;; First a dirty, but cheap way to get .emacs.d subfolders into the load path,
;; and then return us to the user home directory, for find-file etc.
(progn (cd "~/.emacs.d/") (normal-top-level-add-subdirs-to-load-path) (cd "~"))

;(add-to-list 'package-archives
;  '("melpa" . "http://melpa.milkbox.net/packages/") t)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
("marmalade" . "http://marmalade-repo.org/packages/")
;; ("melpa" . "http://melpa.milkbox.net/packages/")
))

;(add-to-list 'default-frame-alist '(font . "M+ 1mn-13"))

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

(add-to-list 'load-path "~/.emacs.d/evil")

(add-to-list 'load-path "~/.emacs.d/plugins/tabbar")

(package-initialize)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GOPATH"))

; Org mode
;(add-to-list 'load-path "~/.emacs.d/elpa/org-20130826")
(add-to-list 'load-path "~/.emacs.d/org-mode/lisp")
(add-to-list 'load-path "~/.emacs.d/org-mode/contrib/lisp")
;(setq org-export-backends (cons 'md org-export-backends))
(require 'ox-md)
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
; Setup org mode for dropbox sync
;; Set to the location of your Org files on your local system
(setq org-directory "~/Dropbox/Todo/org/")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/Dropbox/Todo/org/todos.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
; Turn on org mode line truncation by default
'(org-startup-truncated nil)

; we want a couple of languages in Babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)(ruby . t)(sh . t)(R . t)(C . t)(clojure . t)(lisp . t) (sql . t) (js . t)  (emacs-lisp . t) (css . t)  ))


;; menu bar mode only on OS X, just because it's pretty much out of
;; the way, as opposed to sitting right there in the frame.
(if (display-graphic-p)
  (progn
;; turn off toolbar.
    (if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
     (menu-bar-mode 1)) 
     (menu-bar-mode -1))

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

(when (display-graphic-p)(require 'helm))



;(require 'smartparens)
;(require 'smartparens-config)

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
(when (display-graphic-p)
(scroll-bar-mode -1))

;; conditional - add your own init-marmalade or just login manually
(load-library "marmalade")
(when (file-readable-p "modes-init/init-marmalade.el")
  (load-file "modes-init/init-marmalade.el"))

;; Turn on things that auto-load isn't doing for us...
;(yas-global-mode t)

;; Autopair alternative
(when (display-graphic-p)
(flex-autopair-mode t))

;; Rainbow mode for css automatically
(add-hook 'css-mode-hook 'rainbow-mode)

;; Rainbow delimiters for all prog modes
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Git gutter global mode
;(add-hook 'prog-mode-hook 'git-gutter-mode)

;; Smoother scrolling (no multiline jumps.)
;(setq redisplay-dont-pause t
;  scroll-margin 1
;  scroll-step 1
;  scroll-conservatively 10000
;  scroll-preserve-screen-position 1)

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
;(add-hook 'prog-mode-hook
 ;              (lambda ()
  ;              (font-lock-add-keywords nil
   ;              '(("\\<\\(NOTE\\|FIXME\\|TODO\\|BUG\\|HACK\\|REFACTOR\\|THE HORROR\\)" 1 font-lock-warning-face t)))))
;
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
;(require 'powerline)
;(powerline-default-theme)
(require 'visual-progress-mode)
;(load-theme 'soothe t)
;(load-theme 'mccarthy t)
;(load-theme 'cyberpunk)

;; No tabs, only 4 spaces, as default
(setq-default indent-tabs-mode nil)
(setq tab-width 4)

;; Kill the welcome buffer
(setq inhibit-startup-message t)

;; Disable splash screen
(setq inhibit-splash-screen t)

;; Highlight current line
(global-hl-line-mode 1)

;; Highlight indent, for python, maybe more
(defun setup-indentation-mode ()
  (interactive)
  (require 'highlight-indentation)
  (require 'indent-guide)
  (highlight-indentation-mode)
  (indent-guide-mode)
  )
(add-hook 'python-mode-hook 'setup-indentation-mode)

;; Shortcurt for selecting lispy ranges
(defun evil-select-lisp-form ()
  (interactive)
  (evil-visual-char)
  (evil-jump-item)
  )
(global-set-key (kbd "C-5") 'evil-select-lisp-form)

(setq make-backup-files nil) ; stop creating those backup~ files
(setq auto-save-default nil) ; stop creating those #autosave# files

(recentf-mode 1) ; keep a list of recently opened files

(global-set-key (kbd "C-9") 'zencoding-expand-line)


;; Simple Functions to Control Spotify
(defun spotify-next-track ()
  ;; Go to next track
  (interactive)
  (shell-command "osascript -e 'tell application \"Spotify\" to next track'"))

(defun spotify-info-track ()
  ;; Print Track info as message in mini buffer
  (interactive)
  (message (format "%s - %s"
                   (string-trim (shell-command-to-string "osascript -e 'tell application \"Spotify\" to artist of current track'"))
                   (string-trim (shell-command-to-string "osascript -e 'tell application \"Spotify\" to name of current track'")))))

(defun display-mode ()
  ;; show the current mode name as string
  (interactive)
  (message "%s" major-mode))

;; Reload either the current buffer, or reload the current w3m
(defun total-reload ()
  (interactive)
  (cond
   ((string= "w3m-mode" (format "%s" major-mode)) (w3m-reload-this-page))
   (t (revert-buffer))))

;; Load evil
(require 'init-evil)

(evil-leader/set-key "n" 'new-buffer)

(evil-leader/set-key "t" 'switch-to-previous-buffer)

(evil-leader/set-key "re" 'recentf-open-files)
(evil-leader/set-key "rl" 'total-reload)

(evil-leader/set-key "l" 'buffer-list-in-window)

(evil-leader/set-key "i" 'imenu)

(evil-leader/set-key "c" 'delete-window)
(evil-leader/set-key "p" 'switch-to-prev-buffer)
(evil-leader/set-key ":" 'helm-complex-command-history)

(evil-leader/set-key "f" 'ace-jump-mode)
(evil-leader/set-key "e" 'projectile-find-file)

(evil-leader/set-key "/" 'evilnc-comment-or-uncomment-lines)

(evil-leader/set-key "son" 'spotify-next-track)
(evil-leader/set-key "soi" 'spotify-info-track)

;; Evil leader docs
(defun evil-leader-docs ()
  (interactive)
  (message "Evil Leader Docs (,h):
  n: new buffer
  t: switch to previous buffer
  re: recent open files
  rl: revert buffer
  l: list all open buffers
  i: open imenu
  c: delete the current window
  p: switch to previous buffer
  ':': show command history
  f: ace jump
  e: projectile find file
  /: comment or uncomment line/s
  son: spotify next track
  soi: spotify current track info
  h: this help
"))
(evil-leader/set-key "h" 'evil-leader-docs)



; evil extension for html tag selection like matchit
(require 'evil-matchit)
(global-evil-matchit-mode 1)

(require 'my-functions)

(require 'custom-keys)

; load evil surround
(require 'surround)
(global-surround-mode 1)

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

(when (display-graphic-p)
(helm-mode 1)
(global-set-key (kbd "s-.") 'helm-complete-file-name-at-point))

(require 'init-hideshowvis)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(add-to-list (quote default-frame-alist))
 '(custom-safe-themes
   (quote
    ("c377a5f3548df908d58364ec7a0ee401ee7235e5e475c86952dc8ed7c4345d8e" default)))
 '(fci-rule-character-color "#C9C9C9")
 '(fringe-mode 4 nil (fringe))
 '(httpd-port 8187)
 '(main-line-color1 "#A5A5A5")
 '(main-line-color2 "#B9B9B9")
 '(main-line-separator-style (quote chamfer))
 '(org-agenda-files (quote ("~/Dropbox/Todo/org/grand-todo.org")))
 '(powerline-color1 "#A5A5A5")
 '(powerline-color2 "#B9B9B9")
 '(send-mail-function (quote mailclient-send-it))
 '(sql-postgres-options nil))

 ; set different linum color
; and cua mode for copy / paste
(cua-mode)

(setq evil-default-cursor t)
(set-cursor-color "#ffffff")

; Terminal
;(require 'init-term)

; Multicursor
(require 'init-multicursor)

;(require 'multi-web-mode)



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

; file browser (useful especially for scala stuff with the huge directory tree)
(require 'direx)
(require 'popwin)
(push '(direx:direx-mode :position left :width 25 :dedicated t)
      popwin:special-display-config)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory-other-window)

; Also, we want to move windows around
(require 'buffer-move)
(global-set-key (kbd "<C-s-up>")     'buf-move-up)
(global-set-key (kbd "<C-s-down>")   'buf-move-down)
(global-set-key (kbd "<C-s-left>")   'buf-move-left)
(global-set-key (kbd "<C-s-right>")  'buf-move-right)

; Setup mail in emacs
(require 'init-mail)

; my task mode
;(require 'task-mode)
; and set up leaders for it
;(evil-leader/set-key-for-mode 'task-mode "d" 'task-mode-todo-task)
;(evil-leader/set-key-for-mode 'task-mode "a" 'task-mode-archive-done)
;(evil-leader/set-key-for-mode 'task-mode "c" 'task-mode-new-todo)

;(setq linum-format "%4d")
(ac-linum-workaround)

(require 'tabbar)

(require 'projectile)
(projectile-global-mode)
(setq projectile-completion-system 'grizzl)

; quick hacked function for quick rest client
; testing
(defun testrest ()
  (interactive)
  (with-current-buffer (get-buffer "restrest")
    (restclient-http-send-current-raw)
    )
  )

(global-set-key (kbd "s-r") 'testrest)

; Font lock mode variations to maybe speed up scrolling
;(setq font-lock-support-mode 'fast-lock-mode ; lazy-lock-mode  / jit-lock-mode
;(setq jit-lock-defer-time 0.05) ; http://tsengf.blogspot.de/2012/11/slow-scrolling-speed-in-emacs.html
; http://stackoverflow.com/questions/3631220/fix-to-get-smooth-scrolling-in-emacs
(setq redisplay-dont-pause t
  scroll-margin 1
  scroll-step 1
  scroll-conservatively 10000
  scroll-preserve-screen-position 1
  jit-lock-defer-time 0.05
  font-lock-support-mode 'jit-lock-mode)
(setq-default scroll-up-aggressively 0.01 scroll-down-aggressively 0.01) 

;If you never expect to have to display bidirectional scripts, like
;Arabic, you can make that the default:
(setq-default bidi-paragraph-direction 'left-to-right)

; TODO Emacs:
; - das  terminal wenn am rand, wackelt so schlimm
; - org mode doku downloaden und irgendwo hinterlegen
; - den simple task mode bei github hinterlegen und dann ueber elpa laden
; - completion im terminal tuts noch immer nicht
; - get objective-c completion working
; - better CSS completion
; - better python mode, still sucks a bit
; - integrate ace-jump into the vim workflow, maybe with ,f ?
; - flex-autopair causes wrong html >< insertions
; - in custom-keys I have (global-set-key [(control tab)] 'completion-at-point) but that opens in buffer, what opens that in menu?
; - What does 'load-library do? What am I supposed to load there?
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(require 'web-mode)

(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.blade\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist
'("/\\(views\\|html\\|theme\\|templates\\)/.*\\.php\\'" . web-mode))

; Clojure..
; docs: https://github.com/clojure-emacs/cider
; C-c C-m : invoke macro-expand at point
; repl M-p M-n back forth history
; repl C-j new line-indent
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
(setq nrepl-hide-special-buffers t)
(setq cider-repl-pop-to-buffer-on-connect t)
(setq cider-auto-select-error-buffer t)
(add-hook 'cider-repl-mode-hook 'paredit-mode)
(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)

(require 'ac-cider)
(add-hook 'cider-mode-hook 'ac-flyspell-workaround)
(add-hook 'cider-mode-hook 'ac-cider-setup)
(add-hook 'cider-repl-mode-hook 'ac-cider-setup)
(eval-after-load "auto-complete"
  '(progn
     (add-to-list 'ac-modes 'cider-mode)
     (add-to-list 'ac-modes 'cider-repl-mode)))

;; show fn docs on tab
(defun set-auto-complete-as-completion-at-point-function ()
  (setq completion-at-point-functions '(auto-complete)))

(add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
(add-hook 'cider-mode-hook 'set-auto-complete-as-completion-at-point-function)

;; Show quick help faster
(setq ac-quick-help-delay 0.2)

;; Clojure Grimoire (better docs)
; on symbol: mx clojure-grimoire
; or: C-c C-d g
;; when working offline, can install grimoire offline:
;; https://github.com/clojure-grimoire/grimoire/


(eval-after-load 'go-mode
  '(progn
     (require 'go-autocomplete)
     (require 'auto-complete-config)
     (setq exec-path (cons "/usr/local/go/bin" exec-path))
     (add-to-list 'exec-path "/Users/tleyden/Development/gocode/bin")
     (add-hook 'before-save-hook 'gofmt-before-save)
     )
  )

(defun my-go-mode-hook ()
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump))
(add-hook 'go-mode-hook 'my-go-mode-hook)


(eval-after-load 'web-mode
  '(progn
     (defun prelude-web-mode-defaults ()
       ;; Disable whitespace-mode when using web-mode
       (whitespace-mode -1)
       ;; Customizations
       (setq web-mode-markup-indent-offset 4)
       (setq web-mode-css-indent-offset 2)
       (setq web-mode-code-indent-offset 4)
       (setq web-mode-disable-autocompletion t)
       (local-set-key (kbd "RET") 'newline-and-indent))
     (setq prelude-web-mode-hook 'prelude-web-mode-defaults)

     (add-hook 'web-mode-hook (lambda ()
                                 (run-hooks 'prelude-web-mode-hook)))))


(provide 'init-multi-web-mode)

(require 'code-wrap)

(setq shell-file-name "bash")

(require 'evil-matchit)
(global-evil-matchit-mode 1)

;; Winner-mode:
;; undo / redo for window configurations (opening, closing, splitting, etc)
;; C-c left goes back
;; C-c right goes forward
;; i.e. the arrow keys left / right
(when (fboundp 'winner-mode)
      (winner-mode 1))


(defun accents ()
  (interactive)
  (set-language-environment "UTF-8")
  (activate-input-method "latin-1-alt-postfix"))

(defun current-lang ()
  (interactive)
  (eval-expression current-language-environment))

; Dash integration
(global-set-key "\C-cd" 'dash-at-point)

; Share symmetric keys when opening encrypted fiels
(setq epa-file-cache-passphrase-for-symmetric-encryption t)

;; Browsing html docs from within emacs
(require 'w3m)
;; evil in w3m
(define-key w3m-mode-map (kbd "ESC") 'evil-normal-state)
(define-key w3m-mode-map (kbd "C-g") 'evil-normal-state)
(setq w3m-home-page "about:blank")
(setq w3m-use-cookies t)

;; Postgres browsing in emacs
;; Local dev server data
(setq sql-postgres-login-params
      '((user :default "terhechte")
        (database :default "pdengage")
        (server :default "192.168.2.138")
        (password :default)
        (port :default 5432)))
(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (toggle-truncate-lines t)))

;; Add tab bar mode settings
;; https://gist.github.com/3demax/1264635
;; Tabbar
(require 'tabbar)
;; Tabbar settings
(set-face-attribute
 'tabbar-default nil
 :background "gray20"
 :foreground "gray20"
 :box '(:line-width 1 :color "gray20" :style nil))
(set-face-attribute
 'tabbar-unselected nil
 :background "gray30"
 :foreground "white"
 :box '(:line-width 5 :color "gray30" :style nil))
(set-face-attribute
 'tabbar-selected nil
 :background "gray75"
 :foreground "black"
 :box '(:line-width 5 :color "gray75" :style nil))
(set-face-attribute
 'tabbar-highlight nil
 :background "white"
 :foreground "black"
 :underline nil
 :box '(:line-width 5 :color "white" :style nil))
(set-face-attribute
 'tabbar-button nil
 :box '(:line-width 1 :color "gray20" :style nil))
(set-face-attribute
 'tabbar-separator nil
 :background "gray20"
 :height 0.6)
 
;; Change padding of the tabs
;; we also need to set separator to avoid overlapping tabs by highlighted tabs
(custom-set-variables
 '(tabbar-separator (quote (0.5))))
;; adding spaces
(defun tabbar-buffer-tab-label (tab)
  "Return a label for TAB.
That is, a string used to represent it on the tab bar."
  (let ((label  (if tabbar--buffer-show-groups
                    (format "[%s]  " (tabbar-tab-tabset tab))
                  (format "%s  " (tabbar-tab-value tab)))))
    ;; Unless the tab bar auto scrolls to keep the selected tab
    ;; visible, shorten the tab label to keep as many tabs as possible
    ;; in the visible area of the tab bar.
    (if tabbar-auto-scroll-flag
        label
      (tabbar-shorten
       label (max 1 (/ (window-width)
                       (length (tabbar-view
                                (tabbar-current-tabset)))))))))

;; http://emacswiki.org/emacs/TabBarMode

;; Add a buffer modification state indicator in the tab label, and place a
 ;; space around the label to make it looks less crowd.
 (defadvice tabbar-buffer-tab-label (after fixup_tab_label_space_and_flag activate)
   (setq ad-return-value
         (if (and (buffer-modified-p (tabbar-tab-value tab))
                  (buffer-file-name (tabbar-tab-value tab)))
             (concat " * " (concat ad-return-value " "))
           (concat " " (concat ad-return-value " ")))))

;; Called each time the modification state of the buffer changed.
 (defun ztl-modification-state-change ()
   (tabbar-set-template tabbar-current-tabset nil)
   (tabbar-display-update))

;; First-change-hook is called BEFORE the change is made.
 (defun ztl-on-buffer-modification ()
   (set-buffer-modified-p t)
   (ztl-modification-state-change))
 (add-hook 'after-save-hook 'ztl-modification-state-change)
(add-hook 'first-change-hook 'ztl-on-buffer-modification)

;; Create tab groups by buffers in the same directory. sounds sane
(setq tabbar-cycle-scope 'tabs)
(setq tabbar-buffer-groups-function
      (lambda ()
        (let ((dir (expand-file-name default-directory)))
          (cond ((member (buffer-name) '("*Completions*"
                                         "*scratch*"
                                         "*Messages*"
                                         "*Ediff Registry*"))
                 (list "#misc"))
                ((string-match-p "/.emacs.d/" dir)
                 (list ".emacs.d"))
                (t (list dir))))))

(setq tabbar-use-images nil)

;; use apple-[ and apple-] to switch tabs
(global-set-key (kbd "s-[") 'tabbar-backward-tab)
(global-set-key (kbd "s-]") 'tabbar-forward-tab)
 
(tabbar-mode 1)
(setq tabbar-use-images nil)

;; Auto complete only on tab. might want to do this only for clojure mode?
;; where auto complete is rather slow
(setq ac-auto-start nil)
(define-key ac-mode-map [(tab)] 'auto-complete)
