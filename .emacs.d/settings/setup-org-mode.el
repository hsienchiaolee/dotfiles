;;; setup-org-mode.el --- Set up org-mode and org-roam -*- lexical-binding: t; -*-
;;; Commentary:

;; Org-mode configuration with org-roam for personal knowledge management.
;; Notes are stored in ~/org/roam/.

;;; Code:

(use-package org
  :ensure t
  :custom
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-startup-indented t)
  (org-startup-folded "showeverything")
  :hook (
         (org-mode . (lambda () (setq fill-column 120)))
         (org-mode . turn-on-auto-fill)
         (org-mode . visual-line-mode)
         )
  :config
  (define-key org-mode-map (kbd "RET") 'org-return-indent)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((shell . t)
     (python . t)
     (ruby . t)
     (emacs-lisp . t))))

(use-package org-mcp
  :ensure t
  :vc (:url "https://github.com/hsienchiaolee/org-mcp.git" :rev :newest)
  :after org)

(declare-function org-roam-db-sync "org-roam-db")

(defun my/org-roam-promote-dir-locals ()
  "Use directory-local Org Roam settings as the active defaults."
  (when (and (boundp 'org-roam-directory)
             (local-variable-p 'org-roam-directory))
    (let ((directory org-roam-directory)
          (db-location (or (and (local-variable-p 'org-roam-db-location)
                                org-roam-db-location)
                           (expand-file-name "org-roam.db" org-roam-directory))))
      (unless (and (default-boundp 'org-roam-directory)
                   (equal (default-value 'org-roam-directory) directory)
                   (default-boundp 'org-roam-db-location)
                   (equal (default-value 'org-roam-db-location) db-location))
        (setq-default org-roam-directory directory)
        (setq-default org-roam-db-location db-location)
        (when (bound-and-true-p org-roam-db-autosync-mode)
          (org-roam-db-sync))))))

(use-package org-roam
  :ensure t
  :init
  (setq-default org-roam-directory (expand-file-name "~/org/roam/"))
  :custom
  (org-roam-completion-everywhere t)
  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n l" . org-roam-buffer-toggle)
         ("C-c n c" . org-roam-capture)
         ("C-c n d" . org-roam-dailies-goto-today))
  :hook (hack-local-variables . my/org-roam-promote-dir-locals)
  :config
  (org-roam-db-autosync-mode))

(provide 'setup-org-mode)
;;; setup-org-mode.el ends here
