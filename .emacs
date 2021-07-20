;; .emacs

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; enable visual feedback on selections
;(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
;(setq require-final-newline 'query)

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)

;; Remove whitespaces on save
(add-hook 'before-save-hook
          'delete-trailing-whitespace)

;; line and column numbers
(global-linum-mode t)
(setq column-number-mode t)

; Vim brackets
(defun forward-or-backward-sexp (&optional arg)
  "Go to the matching parenthesis character if one is adjacent to point."
  (interactive "^p")
  (cond ((looking-at "\\s(") (forward-sexp arg))
        ((looking-back "\\s)" 1) (backward-sexp arg))
        ;; Now, try to succeed from inside of a bracket
        ((looking-at "\\s)") (forward-char) (backward-sexp arg))
        ((looking-back "\\s(" 1) (backward-char) (forward-sexp arg))))

; which-function-mode
(setq which-function-mode 1)

;; to setup tabs
(setq-default indent-tabs-mode nil)
(setq c-basic-indent 2)
(setq tab-width 4)

;; Packages
(package-initialize)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ;("marmalade" . "http://marmalade-repo.org/packages/")
                         ;("melpa" . "http://melpa.milkbox.net/packages/"))
                         ("melpa" . "http://melpa.org/packages/")))

;; Melpa Repository
;(when (>= emacs-major-version 24)
;  (require 'package)
;  (package-initialize)
;  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
;  )

;;------------------------------------------------------------------------------
;; Auto install packages
;;------------------------------------------------------------------------------
;; Define a utility function which either installs a package (if it is
;; missing) or requires it (if it already installed).
(defun package-require (pkg &optional require-name)
  "Install a package only if it's not already installed."
  (when (not (package-installed-p pkg))
    (package-install pkg))
  (if require-name
      (require require-name)
    (require pkg)))

;;------------------------------------------------------------------------------
;; Custom Themes
;;------------------------------------------------------------------------------
(package-require 'sublime-themes)
;(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(add-to-list 'custom-theme-load-path "~/.emacs.d/elpa/sublime-themes-20170606.1844")
(load-theme 'spolsky t)

;;------------------------------------------------------------------------------
;; Erlang
;;------------------------------------------------------------------------------
;; Install the official Erlang mode
(package-require 'erlang)

;; Include the Language Server Protocol Clients
;(package-require 'lsp-mode)

;; Erlang
(setq load-path (cons  "~/.emacs.d/elpa/erlang-20140605.1649/"
        load-path))
(setq erlang-root-dir "/usr/lib/erlang/bin/")
(setq exec-path (cons "/usr/lib/erlang/bin//bin/" exec-path))
;(setq erlang-root-dir "/opt/erlang/erlang-r23.2")
;(setq exec-path (cons "/opt/erlang/erlang-r23.2/bin" exec-path))
(require 'erlang-start)

;;------------------------------------------------------------------------------
;; LSP
;;------------------------------------------------------------------------------
;; Customize prefix for key-bindings
(setq lsp-keymap-prefix "C-l")

;; Enable LSP for Erlang files
(add-hook 'erlang-mode-hook #'lsp)

;; Require and enable the Yasnippet templating system
;(package-require 'yasnippet)
;(yas-global-mode t)

;; Enable logging for lsp-mode
(setq lsp-log-io t)

;; Show line and column numbers
(add-hook 'erlang-mode-hook 'linum-mode)
(add-hook 'erlang-mode-hook 'column-number-mode)

;; Enable and configure the LSP UI Package
;(package-require 'lsp-ui)
(setq lsp-ui-sideline-enable t)
(setq lsp-ui-doc-enable t)
(setq lsp-ui-doc-position 'bottom)

;; Enable LSP Origami Mode (for folding ranges)
;(package-require 'lsp-origami)
(add-hook 'origami-mode-hook #'lsp-origami-mode)
(add-hook 'erlang-mode-hook #'origami-mode)

;; Provide commands to list workspace symbols:
;; - helm-lsp-workspace-symbol
;; - helm-lsp-global-workspace-symbol
(package-install 'helm-lsp)

;; Which-key integration
;(package-require 'which-key)
(add-hook 'erlang-mode-hook 'which-key-mode)
(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))

;; Always show diagnostics at the bottom, using 1/3 of the available space
(add-to-list 'display-buffer-alist
             `(,(rx bos "*Flycheck errors*" eos)
              (display-buffer-reuse-window
               display-buffer-in-side-window)
              (side            . bottom)
              (reusable-frames . visible)
              (window-height   . 0.33)))


; EDTS
;;------------------------------------------------------------------------------
;; Setup paths
;;------------------------------------------------------------------------------
;(add-to-list 'load-path "~/.emacs.d/elpa/edts-20201110.1827/")

;;------------------------------------------------------------------------------
;; Custom key bindings
;;------------------------------------------------------------------------------
(eval-after-load 'erlang-mode
                    '(define-key erlang-mode-map "\C-x\C-e" 'erlang-send-to-shell))

;;------------------------------------------------------------------------------
;; Custom funs
;;------------------------------------------------------------------------------
(defun erlang-send-to-shell ()
  (interactive)
  (comint-send-string (get-buffer "*erlang*") (concat (thing-at-point 'line) "\n")))

;;------------------------------------------------------------------------------
;; Custom auto-modes
;;------------------------------------------------------------------------------
;;(yas/load-directory (expand-file-name "~/.emacs.d/snippets/"))
(add-to-list 'auto-mode-alist '("\\.hrl" . erlang-mode))
(add-to-list 'auto-mode-alist '("\\.erl" . erlang-mode))
(add-to-list 'auto-mode-alist '("erl.config" . erlang-mode))
(add-to-list 'auto-mode-alist '("\\.md" . markdown-mode))

;;------------------------------------------------------------------------------
;; Requires
;;------------------------------------------------------------------------------

;(require 'edts-start)

;;------------------------------------------------------------------------------
;; Custom vars
;;------------------------------------------------------------------------------
(setq erlang-root-dir "/usr/lib/erlang/bin/")
(setq exec-path (cons "/usr/lib/erlang/bin//bin/" exec-path))
;(setq edts-man-root "~/.emacs.d/edts/doc/R15B03")
(setq indent-tabs-mode nil)

;;------------------------------------------------------------------------------
;; Compile options
;;------------------------------------------------------------------------------
; (setenv "PATH" (concat (getenv "PATH") ":BUILD_PATH"))
; (setq exec-path (append exec-path '("CODE_PATH")))

(global-set-key (kbd "C-<f5>") 'compile)

(defun recompile-quietly ()
  "Re-compile without changing the window configuration."
  (interactive)
  (save-window-excursion
    (recompile)))

(defun compile-or-recompile()
  (interactive)
  (if (get-buffer "*compilation*")
      (recompile-quietly)
    (call-interactively 'compile)))

(setq compile-command "cd .. && albuild clean && albuild build && dialyzer -Wno_undefined_callbacks --src src/*erl && albuild test-oldunit")

; ido mode
(require 'ido)
(ido-mode t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(edts-inhibit-package-check t)
 '(package-selected-packages
   (quote
    (lsp-mode ivy swiper yaml-mode sublime-themes rust-mode python-mode pymacs protobuf-mode markdown-mode magit inf-ruby inf-php go-mode eproject elpy edts alchemist ag))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

; Delete selection mode
(delete-selection-mode 1)

; Desktop save.
;(desktop-save-mode 1)

; Swiper
;(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(global-set-key "\C-s" 'swiper)
;(global-set-key (kbd "C-c C-r") 'ivy-resume)
;(global-set-key (kbd "<f6>") 'ivy-resume)
;(global-set-key (kbd "M-x") 'counsel-M-x)
;(global-set-key (kbd "C-x C-f") 'counsel-find-file)
;(global-set-key (kbd "<f1> f") 'counsel-describe-function)
;(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
;(global-set-key (kbd "<f1> l") 'counsel-find-library)
;(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
;(global-set-key (kbd "C-c g") 'counsel-git)
;(global-set-key (kbd "C-c j") 'counsel-git-grep)
;(global-set-key (kbd "C-c k") 'counsel-ag)
;(global-set-key (kbd "C-x l") 'counsel-locate)
;(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
;(define-key read-expression-map (kbd "C-r") 'counsel-expression-history)

; LISP
;(load (expand-file-name "~/.quicklisp/slime-helper.el"))
;; Replace "sbcl" with the path to your implementation
(setq inferior-lisp-program "sbcl")

;; Move between windows
(windmove-default-keybindings)
