;;; init.el --- Emacs configuration -*- lexical-binding: t -*-

;; Performance tweaks for modern machines
(setq gc-cons-threshold 100000000) ; 100 mb
(setq read-process-output-max (* 1024 1024)) ; 1mb

;; Stop annoying warnings
(setq native-comp-async-report-warnings-errors nil)

;; Bootstrap elpaca
(defvar elpaca-installer-version 0.7)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                 ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                 ,@(when-let ((depth (plist-get order :depth)))
                                                     (list (format "--depth=%d" depth) "--no-single-branch"))
                                                 ,(plist-get order :repo) ,repo))))
                 ((zerop (call-process "git" nil buffer t "checkout"
                                       (or (plist-get order :ref) "--"))))
                 (emacs (concat invocation-directory invocation-name))
                 ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                       "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                 ((require 'elpaca))
                 ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Remove extra UI clutter by hiding the scrollbar, menubar, and toolbar.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Emoji: 😄, 🤦, 🏴, ,  ;; should render as 3 color emojis and 2 glyphs
(defun trqt/set-fonts ()
  "Set the emoji and glyph fonts."
  (when (display-graphic-p)
      (set-fontset-font t 'symbol "Noto Color Emoji" nil 'prepend)
      ;; Set the font. Note: height = px * 100
      (set-face-attribute 'default nil :font "Fantasque Sans Mono" :height 110)
      (set-face-attribute 'fixed-pitch nil :font "Fantasque Sans Mono" :height 110)

      ;; variable pitch font
      (set-face-attribute 'variable-pitch nil :font "Libertinus Sans" :height 140 :weight 'normal)
    )
  )

(add-hook 'after-init-hook 'trqt/set-fonts)
(add-hook 'server-after-make-frame-hook 'trqt/set-fonts)

;; yes/no to y/n
(defalias 'yes-or-no-p 'y-or-n-p)

;; Add unique buffer names in the minibuffer where there are many
;; identical files. This is super useful if you rely on folders for
;; organization and have lots of files with the same name,
;; e.g. foo/index.ts and bar/index.ts.
(require 'uniquify)

;; Automatically insert closing parens
(electric-pair-mode t)

;; Visualize matching parens
(show-paren-mode 1)

;; Prefer spaces to tabs
(setq-default indent-tabs-mode nil)

;; Automatically save your place in files
(save-place-mode t)

;; Save history in minibuffer to keep recent commands easily accessible
(savehist-mode t)

;; Keep track of open files
(recentf-mode t)

;; Keep files up-to-date when they change outside Emacs
(global-auto-revert-mode t)

;; Display line numbers only when in programming modes
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; The `setq' special form is used for setting variables. Remember
;; that you can look up these variables with "C-h v variable-name".
(setq uniquify-buffer-name-style 'forward
      window-resize-pixelwise t
      frame-resize-pixelwise t
      load-prefer-newer t
      ;; indent or auto complete
      tab-always-indent 'complete 
      backup-by-copying t
      ;; Backups are placed into your Emacs directory, e.g. ~/.config/emacs/backups
      ;;backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))
      ;; I'll add an extra note here since user customizations are important.
      ;; Emacs actually offers a UI-based customization menu, "M-x customize".
      ;; You can use this menu to change variable values across Emacs. By default,
      ;; changing a variable will write to your init.el automatically, mixing
      ;; your hand-written Emacs Lisp with automatically-generated Lisp from the
      ;; customize menu. The following setting instead writes customizations to a
      ;; separate file, custom.el, to keep your init.el clean.
      custom-file (expand-file-name "custom.el" user-emacs-directory))

;; Nicer scrolling
(when (>= emacs-major-version 29)
  (pixel-scroll-precision-mode 1))

(or (display-graphic-p)
    (progn
      (xterm-mouse-mode 1)))

;; Elpaca use-package integration
(elpaca elpaca-use-package
  ;; Enable :elpaca use-package keyword.
  (elpaca-use-package-mode)
  ;; Assume :elpaca t unless otherwise specified.
  (setq elpaca-use-package-by-default t))

;; Wait until current queue is empty
(elpaca-wait)

;; No rubbish in my home!
(use-package no-littering
  :config
  (no-littering-theme-backups)
  :init
  (setq no-littering-etc-directory "~/.cache/emacs/etc/"
        no-littering-var-directory "~/.cache/emacs/var/"))

;; A package with a great selection of themes
(use-package ef-themes
  :config
  (ef-themes-select 'ef-autumn))

;; Transparency
(add-to-list 'default-frame-alist '(alpha-background . 90)) 

;; Die DocView
(defalias 'doc-view-mode #'doc-view-fallback-mode) ;Or fundamental-mode, ...

(use-package golden-ratio
  :custom
  (golden-ratio-auto-scale t)
  :init
  (golden-ratio-mode 1))

;; Minibuffer completion is essential to your Emacs workflow and
;; Vertico is currently one of the best out there. There's a lot to
;; dive in here so I recommend checking out the documentation for more
;; details: https://elpa.gnu.org/packages/vertico.html. The short and
;; sweet of it is that you search for commands with "M-x do-thing" and
;; the minibuffer will show you a filterable list of matches.
(use-package vertico
  :custom
  (vertico-cycle t)
  (read-buffer-completion-ignore-case t)
  (read-file-name-completion-ignore-case t)
  (completion-styles '(basic substring partial-completion flex))
  :init
  (vertico-mode))

;; Improve the accessibility of Emacs documentation by placing
;; descriptions directly in your minibuffer. Give it a try:
;; "M-x find-file".
(use-package marginalia
  :after vertico
  :init
  (marginalia-mode))

;; Completion package
(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-quit-no-match 'separator)

  ;; You may want to play with delay/prefix/styles to suit your preferences.
  ;; (corfu-auto-delay 0)
  ;; (corfu-auto-prefix 0)
  (completion-styles '(basic)))

;; Make completion searching sound
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Consult: Misc. enhanced commands
(use-package consult
  :bind (
         ;; Drop-in replacements
         ("C-x b" . consult-buffer)     ; orig. switch-to-buffer
         ("M-y"   . consult-yank-pop)   ; orig. yank-pop
         ;; Searching
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)     ; Alternative: rebind C-s to use
         ("M-s s" . consult-line) ; consult-line instead of isearch, bind
         ("M-s L" . consult-line-multi) ; isearch to M-s s
         ("M-s o" . consult-outline)
         ;; Isearch integration
         :map isearch-mode-map
         ("M-e" . consult-isearch-history) ; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history) ; orig. isearch-edit-string
         ("M-s l" . consult-line) ; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi) ; needed by consult-line to detect isearch
         )
  :config
  ;; Narrowing lets you restrict results to certain groups of candidates
  (setq consult-narrow-key "<"))

;; Contextual actions
(use-package embark
  :demand t
  :bind (("C-c a" . embark-act)))

(use-package embark-consult
  :ensure t)

;; LSP package
(use-package eglot
  :ensure nil
  :bind (("s-<mouse-1>" . eglot-find-implementation)
         ("C-c ." . eglot-code-action-quickfix)
         ("C-c ;" . eglot-code-actions))
  :hook ((go-mode . eglot-ensure)
         (rust-mode . eglot-ensure)
         (haskell-mode . eglot-ensure)
         (tuareg-mode . eglot-ensure)
         (python-mode . eglot-ensure)
         (java-mode . eglot-ensure)
         (c-mode . eglot-ensure)
         (c++-mode . eglot-ensure))
  :custom
  (eglot-autoshutdown t)
  (eglot-confirm-server-initiated-edits nil) ;; DWIM, don't ask to change
  :config
  (fset #'jsonrpc--log-event #'ignore))

;; Add extra context to Emacs documentation to help make it easier to
;; search and understand. This configuration uses the keybindings 
;; recommended by the package author.
(use-package helpful
  :bind (("C-h f" . #'helpful-callable)
         ("C-h v" . #'helpful-variable)
         ("C-h k" . #'helpful-key)
         ("C-c C-d" . #'helpful-at-point)
         ("C-h F" . #'helpful-function)
         ("C-h C" . #'helpful-command)))

;; Which key, make the commands more accessible
(use-package which-key
  :init
  (which-key-mode 1)
  :config
  (setq which-key-side-window-location 'bottom
	which-key-sort-order #'which-key-key-order-alpha
	which-key-sort-uppercase-first nil
	which-key-add-column-padding 1
	which-key-max-display-columns nil
	which-key-min-display-lines 6
	which-key-side-window-slot -10
	which-key-side-window-max-height 0.25
	which-key-idle-delay 0.8
	which-key-max-description-length 25
	which-key-allow-imprecise-window-fit t
	which-key-separator " → " ))

;; Better undo
(use-package undo-tree
  :config
  (setq undo-tree-auto-save-history nil)
  (global-undo-tree-mode 1))

;; VI VI VI
(use-package evil
  :demand t
  :custom
  (evil-want-integration t)
  (evil-want-keybinding nil)
  (evil-want-C-u-scroll t)
  (evil-undo-system 'undo-tree)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-tex
  :after evil
  :hook
  (LaTeX-mode . evil-tex-mode))

;; Make org a bit prettier
(setq-default org-startup-indented t
              org-pretty-entities t
              org-hide-emphasis-markers t
              org-startup-with-inline-images t
              org-image-actual-width '(300))

(use-package org-appear
    :hook
    (org-mode . org-appear-mode))
(use-package org-modern
    :hook
    (org-mode . global-org-modern-mode)
    (org-mode . variable-pitch-mode))

(use-package org-faces
  :ensure nil
  :config
  ;; Increase the size of various headings
  (set-face-attribute 'org-document-title nil :font "Libertinus Serif" :weight 'medium :height 1.3)
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Libertinus Serif" :weight 'medium :height (cdr face))))

;; Spell checking
(use-package jinx
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages)))

;; Why obsidian when we have public, free and of quality software
(use-package denote
  :custom
  (denote-known-keywords '("emacs" "journal"))
  ;; This is the directory where your notes live.
  (denote-directory (expand-file-name "~/docs/denote/"))
  :config
  (require 'ox-md)
  :bind
  (("C-c n n" . denote)
   ("C-c n f" . denote-open-or-create)
   ("C-c n i" . denote-link)))

;; An extremely feature-rich git client. Activate it with "C-c g".
(use-package magit
  :bind (("C-c g" . magit-status)))

;; Make focused windows more obvious
(use-package breadcrumb
  :ensure (:fetcher github :repo "joaotavora/breadcrumb")
  :init (breadcrumb-mode))

;; As you've probably noticed, Lisp has a lot of parentheses.
;; Maintaining the syntactical correctness of these parentheses
;; can be a pain when you're first getting started with Lisp,
;; especially when you're fighting the urge to break up groups
;; of closing parens into separate lines. Luckily we have
;; Paredit, a package that maintains the structure of your
;; parentheses for you. At first, Paredit might feel a little
;; odd; you'll probably need to look at a tutorial (linked
;; below) or read the docs before you can use it effectively.
;; But once you pass that initial barrier you'll write Lisp
;; code like it's second nature.
;; http://danmidwood.com/content/2014/11/21/animated-paredit.html
;; https://stackoverflow.com/a/5243421/3606440
(use-package paredit
  :hook ((emacs-lisp-mode . enable-paredit-mode)
         (lisp-mode . enable-paredit-mode)
         (ielm-mode . enable-paredit-mode)
         (lisp-interaction-mode . enable-paredit-mode)
         (scheme-mode . enable-paredit-mode)))

;; (use-package treesit-auto
;;   :custom
;;   (treesit-auto-install 'prompt)
;;   :config
;;   (treesit-auto-add-to-auto-mode-alist 'all)
;;   (global-treesit-auto-mode))

(use-package go-mode
  :bind (:map go-mode-map
	      ("C-c C-f" . 'gofmt))
  :hook (before-save . gofmt-before-save))

(use-package markdown-mode
  :hook (markdown-mode . visual-line-mode)
  :init
  (setq markdown-command "pandoc --mathml"))

;; C configs
(use-package c-mode
  :ensure nil
  :custom
  (c-default-style "bsd")
  (c-basic-offset 4)
  :bind (:map c-mode-map
              ("C-c C-c" . compile)
              ("C-c C-f" . eglot-format)))

(use-package rust-mode
  :bind (:map rust-mode-map
	      ("C-c C-r" . 'rust-run)
	      ("C-c C-c" . 'rust-compile)
	      ("C-c C-f" . 'rust-format-buffer)
	      ("C-c C-t" . 'rust-test))
  :hook (rust-mode . prettify-symbols-mode))

(use-package haskell-mode
  :hook (haskell-mode . prettify-symbols-mode)
  :bind (:map haskell-mode-map
              ("C-c C-c" . haskell-compile)))

;; OCaml
(use-package tuareg
  :mode (("\\.ocamlinit\\'" . tuareg-mode)))

;; Matrix support
(use-package ement
  :ensure (:fetcher github :repo "alphapapa/ement.el"))

;; RSS support
(use-package elfeed
  :custom
  (elfeed-db-directory
   (expand-file-name "elfeed" user-emacs-directory))
  :bind (("C-c w" . 'elfeed)))

(use-package elfeed-org
  :config
  (elfeed-org)
  :custom
  (rmh-elfeed-org-files
   (list (concat (file-name-as-directory
              (getenv "HOME"))
                 "docs/elfeed.org"))))

;; Social stuff
(use-package tracking)

;; IRC

;; Telegram
(setq org-file-apps
      '((auto-mode . emacs)
        (directory . emacs)
        ("\\.pdf\\'" . "xdg-open %s")
        ("\\.epub\\'" . "xdg-open %s")
        ("\\.djvu\\'" . "xdg-open %s")
        (t . "xdg-open %s"))) ;; xdg-open to open files
(use-package telega
  :config
  (setq telega-use-tracking-for '(or unmuted mention)
        telega-completing-read-function #'completing-read
        telega-msg-rainbow-title t
        telega-chat-fill-column 75
        telega-server-libs-prefix "~/.nix-profile"
        telega-use-images t
        telega-open-file-function 'org-open-file
        telega-chat-show-deleted-messages-for '(not saved-messages)))

;; LaTeX and Scientific Writing
(defun trqt/latex-electric-math ()
  (set (make-local-variable 'TeX-electric-math)
                          (cons "\\(" "\\)")))

(use-package auctex
  :hook
  ((LaTeX-mode . prettify-symbols-mode)
   (LaTeX-mode . trqt/latex-electric-math))
  :custom 
  (reftex-plug-into-AUCTeX t)
  (TeX-auto-save t)
  (TeX-fold-mode t)
  (TeX-parse-self t)
  ;;(setq-default TeX-master nil)         ; ask for master file
  :ensure                               ; needed for installation
  (auctex :repo "https://git.savannah.gnu.org/git/auctex.git" :branch "main"
          :pre-build (("make" "elpa"))
          :build (:not elpaca--compile-info) ;; Make will take care of this step
          :files ("*.el" "doc/*.info*" "etc" "images" "latex" "style")
          :version (lambda (_) (require 'tex-site) AUCTeX-version)))

(use-package cdlatex
  :custom
  (cdlatex-takeover-dollar nil)
  :hook
  (LaTeX-mode . turn-on-cdlatex)
  (org-mode . turn-on-org-cdlatex))

(use-package citar
  :custom
  (org-cite-global-bibliography '("~/docs/references.bib"))

  (org-cite-insert-processor 'citar)
  (org-cite-follow-processor 'citar)
  (org-cite-activate-processor 'citar)

  (citar-bibliography org-cite-global-bibliography)
  :hook
  (LaTeX-mode . citar-capf-setup)
  (org-mode . citar-capf-setup)
  :bind (:map org-mode-map
              :package org ("C-c b" . org-cite-insert)))

(use-package citar-embark
  :after citar embark
  :no-require
  :config (citar-embark-mode))
