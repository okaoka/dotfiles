;; when using older version emacs
;; define "user-emacs-directory" value
(when (< emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d/"))

;; define load-path adding function
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
    (normal-top-level-add-subdirs-to-load-path))))))

;; load some dirs
(add-to-load-path "elisp" "conf" "public_repos" "inits")

(when (require 'auto-install nil t)
  ;; set install dir
  (setq auto-install-directory "~/.emacs.d/elisp/")
  ;; get elisp name from EmacsWiki
  (auto-install-update-emacswiki-package-name t)
  ;; enable install-elisp function
  (auto-install-compatibility-setup))

(require 'package)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org./packages/"))
(add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

(require `cl)
(defvar installing-package-list	
  `(
    popup
    auto-async-byte-compile
    color-theme
    php-mode
    markdown-mode
    auto-complete
    flymake
    helm
    flymake-php
    redo+
    perl-completion
    web-mode
    magit
    quickrun
    plsense
    ))
(defun installing-package-list-installed-p ()
  (loop for p in installing-package-list
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))
 
(unless (installing-package-list-installed-p)
  ;; check for new packages (package versions)
  (package-refresh-contents)
  ;; install the missing packages
  (dolist (p installing-package-list)
    (when (not (package-installed-p p))
      (package-install p))))

;;helm
(when (require 'helm-config nil t)
  (helm-mode 1)

  (define-key global-map (kbd "M-x")     'helm-M-x)
  (define-key global-map (kbd "C-x C-f") 'helm-find-files)
  (define-key global-map (kbd "C-x C-r") 'helm-recentf)
  (define-key global-map (kbd "M-y")     'helm-show-kill-ring)
  (define-key global-map (kbd "C-c i")   'helm-imenu)
  (define-key global-map (kbd "C-x b")   'helm-buffers-list))

;; color-theme
(when (require 'color-theme nil t)
  (color-theme-initialize)
  (color-theme-hober))

;; auto-complete
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
	       "~/.emacs.d/elisp/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

;; use C-h as a backspace
(keyboard-translate ?\C-h ?\C-?)

;; help show C-x ?
(define-key global-map (kbd "C-x ?") 'help-command)

;; php-mode setting
(when (require 'php-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.ctp\\'" . php-mode))
  (setq php-search-url "http://jp.php.net/ja/")
  (setq php-manual-url "http://jp.php.net/manual/ja/"))

;; indent setting of php-mode
(defun php-indent-hook ()
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4)
  ;; (c-set-offset 'case-label '+); case label of the switch sentence
  (c-set-offset 'arglist-intro '+) ; 
  (c-set-offset 'arglist-close 0)) ; close bracket of the array
  
(add-hook 'php-mode-hook 'php-indent-hook)  

;;php-completion setting
(defun php-completion-hook()
  (when (require 'php-completion nil t)
    (php-completion-mode t)
    (define-key php-mode-map (kbd "C-o") 'phpcmp-complete)

    (when (require 'auto-complete nil t)
      (make-variable-buffer-local 'ac-sources)
      (add-to-list 'ac-sources 'ac-source-php-completion)
      (auto-complete-mode t))))
(add-hook 'php-mode-hook 'php-completion-hook)

;;perl-completion setting
(defun perl-completion-hook()
  (when (require 'perl-completion nil t)
    (perl-completion-mode t)
    (when (require 'auto-complete nil t)
      (auto-complete-mode t)
      (make-variable-buffer-local 'ac-sources)
      (setq ac-sources
	    '(ac-source-perl-completion)))))
(add-hook 'cperl-mode-hook 'perl-completion-hook)

;;gdb
(add-hook 'gdb-mode-hook '(lambda () (gud-tooltip-mode t)))
(setq gdb-many-windows t)

;;auto compile
;;(install-elisp "http://www.emacswiki.org/emacs/download/auto-async-byte-compile.el")
(when (require 'auto-async-byte-compile nil t)
  (setq auto-async-byte-compile-exclude-files-regexp "/junk/")
  (add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode))

;;web-mode setting
(when (require 'web-mode nil t)
  ;;filename extensions
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.ctp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsp\\'" , web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" , web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

  ;;indent for web-mode
  (defun web-mode-hook ( )
    "Hooks for web mode."
    (setq web-mode-markup-indent-offset 2); indent for HTML
    (setq web-mode-css-indent-offset 2); indent for CSS
    (setq web-mode-code-indent-offset 2); indent for JS,PHP,Ruby,...L
    (setq web-mode-comment-style 2); indent for comments
    (setq web-mode-style-padding 1); indent level for <style>
    (setq web-mode-script-padding 1); indent level for <script>
    )
  (add-hook 'web-mode-hook 'web-mode-hook)
)


;;flymake-php
(when (require 'flymake-php nil t)
  (add-hook 'php-mode-hook 'flymake-php-load))


