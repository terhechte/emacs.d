# Emacs-Evil Configuration

This is my in-progress Emacs configuration which tries to be something in between Vim and Emacs. Emacs strong configuration facilities make it possible that I am very, very comfortable in this editor while I can barely manage to exit a regular Emacs on the command line. Meaning, this configuration is so specific that there's little resemblance to classic Emacs anymore. However, if you're coming from Vim, this Emacs configuration could be a good fit - even though it also differs quite a lot from Vim, but maybe not as strong as it differs from Emacs. Of course, all the classic Emacs shortcuts still work, I just don't know about them because I'm using my own facilities or am using the Evil-Vim ones.

![image](https://raw2.github.com/terhechte/emacs.d/master/screenshot.png)

# Features
- This configuration is optimized (kinda) for HTML, Javascript, CSS, Python, Clojure, Scala, Emacs Lisp, and Org Mode. Some set ups are better than others, and not everything may be the latest and greatest. I'm not trying to create the most up to date Emacs configuration, I'm trying to have a pleasant working environment
- Optimized for using it on Mac OS X.
- Tries had to actually look good
- Needs Emacs 24.3+
- Leader support (",") for various tasks
- MX Shortcut to C-.
- Expose-Like Window Switcher with Command-'
- A small documention in emacs-docs.txt
- C-g is the 'quit' key it also goes from insert back to normal mode (i.e. use that instead of ESC or C-c)

# Shortcuts

Here's a list of some keyboard shortcuts that make this configuration pleasant to use

## General
- C-.: MX shortcut (so pleasant, try it!)
- s-0: Line-Numbers on / off
- s-1 - s-4: Split windows in different ways
- s-5: Delete Window
- s-.: helm-complete-filename-at-point: press this for filename completion in a buffer
- s-/:  Hippie Expand, but doesn't have a menu either
- s-': Expose like window switching
- C-c SPC: ace jump mode
- C-u C-u C-c SPC: ace-jump-line-mode
- C-j: Zencoding

## Lisp
- C-': Evaluate thing left of cursor or evaluate region if there is one
- C-5: Will select from here up to the matching item (i.e. from [ to ] or from ( to ))
- C-+ / C--: Will expand or contract the current selection by scope

## Evil Leader
- ,t      Toggle back and forth between last buffers
- ,p      Go to previous buffer (i.e. back button)
- ,n      Open new empty buffer
- ,re     Recent open files
- ,rl     Revert current buffer (reload)
- ,l      List all open buffers (care, this mode is not evil-compatible!)
- ,c      Close current Window
- ,:      Command history (like vim recent commands, not perfect but close)
- ,f      Ace-Jump (i.e. Vim EasyMotion)
- ,/      Toggle comments


# Shortcomings
- This is very much work in progress
- I'm really happy with this setup but constantly tinkering
- High learning curve as there're so many custom shortcuts now

