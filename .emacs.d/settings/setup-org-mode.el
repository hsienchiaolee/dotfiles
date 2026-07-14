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
  (org-directory (expand-file-name "~/org"))
  (org-default-notes-file (expand-file-name "todo.org" org-directory))
  (org-agenda-files (list org-default-notes-file))
  (org-agenda-skip-unavailable-files t)
  :hook (
         (org-mode . (lambda () (setq fill-column 120)))
         (org-mode . turn-on-auto-fill)
         (org-mode . visual-line-mode)
         )
  :config
  (define-key org-mode-map (kbd "RET") 'org-return-indent)

  (defhydra hydra-org (:color blue :hint nil)
    "
Org
^Edit^                   ^Todo^                 ^Time^
^^^^^^---------------------------------------------------------------
_i_: insert heading      _t_: todo              _s_: schedule
_I_: insert subheading   _T_: todo tree         _d_: deadline
_m_: move subtree down   _,_: priority          _e_: effort
_M_: move subtree up     _x_: archive           _c_: clock in
_r_: refile              _o_: open at point     _q_: clock out
_a_: attach

^Agenda^                 ^Export^               ^Links^
^^^^^^---------------------------------------------------------------
_A_: agenda              _E_: export            _l_: store link
_C_: capture             _P_: publish           _L_: insert link
_G_: todo list
"
    ("i" org-insert-heading)
    ("I" org-insert-subheading)
    ("m" org-move-subtree-down :color red)
    ("M" org-move-subtree-up :color red)
    ("r" org-refile)
    ("a" org-attach)
    ("o" org-open-at-point)
    ("t" org-todo)
    ("T" org-show-todo-tree)
    ("," org-priority)
    ("x" org-archive-subtree)
    ("s" org-schedule)
    ("d" org-deadline)
    ("e" org-set-effort)
    ("c" org-clock-in)
    ("q" org-clock-out)
    ("A" org-agenda)
    ("C" org-capture)
    ("G" org-todo-list)
    ("E" org-export-dispatch)
    ("P" org-publish-current-project)
    ("l" org-store-link)
    ("L" org-insert-link)
    ("Q" nil "quit"))

  (global-set-key (kbd "C-c o") 'hydra-org/body)

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
