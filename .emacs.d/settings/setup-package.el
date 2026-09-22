;;; setup-package.el --- Setup package management -*- lexical-binding: t; -*-
;;; Commentary:

;; Configuration for Emacs package management with use-package.

;;; Code:

(require 'package)

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")))

(package-initialize)

(defvar setup-package--refreshed-p nil
  "Whether package archives have been refreshed for this session.")

(defun setup-package--install (install &rest args)
  "Refresh archives once before INSTALL with ARGS, without editing hooks."
  ;; MELPA replaces old builds, so cached download URLs can stop working.
  ;; Installed packages never call `package-install', keeping startup offline.
  (unless setup-package--refreshed-p
    (package-refresh-contents)
    (setq setup-package--refreshed-p t))
  ;; Autoload generation visits Lisp files before dependencies are activated.
  ;; Programming hooks (such as Flycheck) must not run in those buffers.
  (let ((prog-mode-hook nil)
        (emacs-lisp-mode-hook nil))
    (apply install args)))

(advice-add 'package-install :around #'setup-package--install)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

;; Setup commonly used packages early
(use-package hydra
  :ensure t
  :config
  (setq hydra-look-for-remap t)
  )

;; Keep package files clean
(use-package no-littering
  :ensure t
  :demand t
  :config
  (setq auto-save-file-name-transforms
    `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  (setq backup-directory-alist
    `((".*" . ,(no-littering-expand-var-file-name "backup/"))))
  (setq custom-file (expand-file-name "custom.el" user-emacs-directory)))

(provide 'setup-package)
;;; setup-package.el ends here
