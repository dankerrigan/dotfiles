;; Mostly inspired by http://www.aaronbedra.com/emacs.d/

(setq user-full-name "Dan Kerrigan")
(setq user-mail-address "dan@luminal.org")

;; Set up extra path
(setenv "PATH" (concat "/Users/dankerrigan/go/bin:/Users/dankerrigan/.cabal/bin:/usr/local/bin:/opt/local/bin:/usr/bin:/bin" (getenv "PATH")))
(require 'cl)

;; Package Management
(load "package")
(package-initialize)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(setq package-archive-enable-alist '(("melpa" deft magit)))

(defvar dek/packages '(ac-slime
		       ace-jump-mode
                       auto-complete
                       autopair
                       clojure-mode
;;                       clojure-test-mode
                       coffee-mode
                       csharp-mode
                       deft
                       erlang
                       feature-mode
                       flycheck
                       gist
                       go-mode
                       graphviz-dot-mode
                       haskell-mode
                       htmlize
                       magit
                       markdown-mode
                       marmalade
                       nodejs-repl
                       o-blog
                       org
                       paredit
                       restclient
                       rvm
                       smex
                       sml-mode
                       solarized-theme
                       web-mode
                       writegood-mode
                       yaml-mode)
  "Default packages")

(defun dek/packages-installed-p ()
  (loop for pkg in dek/packages
    when (not (package-installed-p pkg)) do (return nil)
    finally (return t)))

(unless (dek/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg dek/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

;; Turn off splash screen, go straight to org
(setq inhibit-splash-screen t
      initial-scratch-message nil)
;;       initial-major-mode 'org-mode)

;; Turn off scroll bar, tool bar, menu bar
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Intuitive text marking
(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)

;; Display settings
(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (set-face-attribute 'default nil
		      :family "Monaco" ;; Incosolata
		      :height 140
		      :weight 'normal
		      :width 'normal)
  (when (functionp 'set-fontset-font)
    (set-fontset-font "fontset-default"
		      'unicode
		      (font-spec :family "Consolas" ;; "DejaVu Sans Mono"
				       :width 'normal
				       :size 12.4
				       :weight 'normal))))
(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

;; Default tab width 2, no actual tabs
(setq tab-width 2
      indent-tabs-mode nil)

;; Turn off backup files
;; (setq make-backup-files nil)

;; y or n vs yes or no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Key bindings
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-c C-k") 'compile)
(global-set-key (kbd "C-x g") 'magit-status)

;; Misc
(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)
(show-paren-mode t)

;; Vendor directory
(defvar dek/vendor-dir (expand-file-name "vendor" user-emacs-directory))
(add-to-list 'load-path dek/vendor-dir)

(dolist (project (directory-files dek/vendor-dir t "\\w+"))
  (when (file-directory-p project)
    (add-to-list 'load-path project)))

;; Org Settings
(setq org-log-done t
      org-todo-keywords '((sequence "TODO" "INPROGRESS" "DONE"))
      org-todo-faces '(("INPROGRESS" . (:forground "blue" :weight bold))))
(add-hook 'org-mode-hook
	  (lambda ()
	    (flyspell-mode)))
(add-hook 'org-mode-hook
	  (lambda ()
	    (writegood-mode)))

;; Org Agenda
(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-agenda-show-log t
      org-agenda-todo-ignore-scheduled t
      org-agenda-todo-ignore-deadlines t)
(setq org-agenda-files (list "~/org/personal.org"))

;; Org Habit
(require 'org)
(require 'org-install)
(require 'org-habit)
(add-to-list 'org-modules "org-habit")
(setq org-habit-preceding-days 7
      org-habit-following-days 1
      org-habit-graph-column 80
      org-habit-show-habits-only-for-today t
      org-habit-show-all-today t)

;; Org babel
;; (require 'ob)

;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((sh . t)
;;    (ditaa . t)
;;    (plantuml . t)
;;    (dot . t)
;;    (ruby . t)
;;    (js . t)
;;    (C . t)))

;; (add-to-list 'org-src-lang-modes (quote ("dot". graphviz-dot)))
;; (add-to-list 'org-src-lang-modes (quote ("plantuml" . fundamental)))
;; (add-to-list 'org-babel-tangle-lang-exts '("clojure" . "clj"))

;; (defvar org-babel-default-header-args:clojure
;;   '((:results . "silent") (:tangle . "yes")))

;; (defun org-babel-execute:clojure (body params)
;;   (lisp-eval-string body)
;;   "Done!")

;; (provide 'ob-clojure)

;; (setq org-src-fontify-natively t
;;       org-confirm-babel-evaluate nil)

;; (add-hook 'org-babel-after-execute-hook (lambda ()
;; 					  (condition-case nil
;; 					      (org-display-inline-images)
;; 					    (error nil)))
;; 	            'append)

;; Org Abbrev
(add-hook 'org-mode-hook (lambda () (abbrev-mode 1)))

;; (define-skeleton skel-org-block-elisp
;;   "Insert an emacs-lisp block"
;;   ""
;;   "#+begin_src emacs-lisp\n"
;;   _ - \n
;;   "#+end_src\n")

;; (define-abbrev org-mode-abbrev-table "elsrc" "" 'skel-org-block-elisp)

;; (define-skeleton skel-org-block-js
;;   "Insert a JavaScript block"
;;   ""
;;   "#+begin_src js\n"
;;   _ - \n
;;   "#+end_src\n")

;; (define-abbrev org-mode-abbrev-table "jssrc" "" 'skel-org-block-js)

;; (define-skeleton skel-header-block
;;   "Creates my default header"
;;   ""
;;   "#+TITLE: " str "\n"
;;   "#+AUTHOR: Aaron Bedra\n"
;;   "#+EMAIL: aaron@aaronbedra.com\n"
;;   "#+OPTIONS: toc:3 num:nil\n"
;;   "#+STYLE: <link rel=\"stylesheet\" type=\"text/css\" href=\"http://thomasf.github.io/solarized-css/solarized-light.min.css\" />\n")

;; (define-abbrev org-mode-abbrev-table "sheader" "" 'skel-header-block)

;; (define-skeleton skel-org-html-file-name
;;   "Insert an HTML snippet to reference the file by name"
;;   ""
;;   "#+HTML: <strong><i>"str"</i></strong>")

;; (define-abbrev org-mode-abbrev-table "fname" "" 'skel-org-html-file-name)

;; Smex, history/searching on top of M-x
(setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;; Ido, file system nav
(ido-mode t)
(setq ido-enable-flex-matching t
      ido-use-virtual-buffers t)

;; Column number mode
(setq column-number-mode t)

;; Temp file management
(setq backup-directory-alest `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transform `((".*" ,temporary-file-directory t)))

;; autopair-mode, ensures (), [], {} are closed
(require 'autopair)

;; auto-complete, turn it on
(require 'auto-complete-config)
(ac-config-default)

;; Indentation and buffer cleanup (reindents, untabifies, cleans up whitespace
(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (indent-buffer)
  (untabify-buffer)
  (delete-trailing-whitespace))

(defun cleanup-region (begin-end)
  "Remove tmux artifacts from region."
  (interactve "r")
  (dolist (re '("\\\\ | \.*\n" "\W* | \.*"))
    (replace-regexp re "" nil beg end)))

(global-set-key (kbd "C-x M-t") 'cleanup-region)
(global-set-key (kbd "C-c n") 'cleanup-buffer)

(setq-default show-trailing-whitespace t)

;; flyspell, spell checking
(setq flyspell-issue-welcome-flag nil)
(if (eq system-type 'darwin)
    (setq-default ispell-program-name "/usr/local/bin/aspell")
  (setq-default ispell-program-name "/usr/bin/aspell"))
(setq-default ispell-list-command "list")

;; Lang hooks
;; shell-script-mode for .zsh files
(add-to-list 'auto-mode-alist '("\\.zsh$" . shell-script-mode))

;; conf-mode
(add-to-list 'auto-mode-alist '("\\.gitconfig$" . conf-mode))

;; Web Mode
(add-to-list 'auto-mode-alist '("\\.hbs$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$" . web-mode))

;; Ruby, turn on autopair for ruby, ID additional names extension to trigger ruby-mode
(add-hook 'ruby-mode-hook
	  (lambda ()
	    (autopair-mode)))

(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile" . ruby-mode))

;; RVM, tell rvm to use default ruby
(rvm-use-default)

;; YAML
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

;; CoffeeScript
(defun coffee-custom ()
  "coffee-mode-hook"
  (make-local-variable 'tab-width)
  (set 'tab-width 2))

(add-hook 'coffee-mode-hook 'coffee-custom)

;; JavaScript mode
(defun js-custom ()
  "js-mode-hook"
  (setq js-indent-level 2))

(add-hook 'js-mode-hook 'js-custom)

;; Markdown Mode
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdown$" . markdown-mode))
(add-hook 'markdown-mode-hook
          (lambda ()
            (visual-line-mode t)
            (writegood-mode t)
            (flyspell-mode t)))
(setq markdown-command "pandoc --smart -f markdown -t html")
(setq markdown-css-path (expand-file-name "markdown.css" dek/vendor-dir))

;; Haskell Mode
(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;; (add-hook `haskell-mode-hook
;; 	  (lambda()
;; 	    ('turn-on-haskell-indent
;; 	     'turn-on-haskell-indentation
;; 	     'turn-on-haskell-doc)))

;; Go Mode
(add-to-list 'auto-mode-alist '("\\.go$".  go-mode))
(add-hook 'go-mode-hook
	  (lambda ()
	    (add-hook 'before-save-hook 'gofmt-before-save)
	    (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)
	    (local-set-key (kbd "C-c i") 'go-goto-imports)
	    (local-set-key (kbd "M-.") 'godef-jump)))

;; Themes
(if window-system
    (load-theme 'solarized-light t)
  (load-theme 'wombat t))
