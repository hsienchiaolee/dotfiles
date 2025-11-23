;;; setup-theme.el --- Setup theme -*- lexical-binding: t; -*-
;;; Commentary:

;; This package sets up the Spacemacs theme and powerline.

;;; Code:

(use-package spacemacs-theme
  :defer t
  :ensure t
  :init
  (setq default-frame-alist '((fullscreen . maximized)))
  (load-theme 'spacemacs-dark t)
  )

(use-package spaceline
  :defer t
  :init
  (setq powerline-default-separator 'slant)
  (setq powerline-height 18)
  )

(use-package spaceline-config
  :demand t
  :ensure spaceline
  :config
  (spaceline-define-segment line-column
    "The current line and column numbers."
    "l:%l c:%2c")
  (spaceline-helm-mode 1)
  (spaceline-spacemacs-theme))

(provide 'setup-theme)
;;; setup-theme.el ends here
