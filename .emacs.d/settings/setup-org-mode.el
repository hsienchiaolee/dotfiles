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

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (expand-file-name "~/org/roam/"))
  (org-roam-completion-everywhere t)
  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n l" . org-roam-buffer-toggle)
         ("C-c n c" . org-roam-capture)
         ("C-c n d" . org-roam-dailies-goto-today))
  :config
  (org-roam-db-autosync-mode))

(provide 'setup-org-mode)
;;; setup-org-mode.el ends here
