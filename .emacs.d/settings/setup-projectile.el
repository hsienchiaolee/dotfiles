;;; setup-projectile.el --- Setup Projectile -*- lexical-binding: t; -*-
;;; Commentary:

;; Configuration for Projectile project management.

;;; Code:

(use-package projectile
  :ensure t
  :init
  (setq projectile-indexing-method 'alien)
  (setq projectile-enable-caching t)
  (setq projectile-sort-order 'recentf)
  (setq projectile-file-exists-remote-cache-expire (* 10 60))
  (setq projectile-require-project-root t)
  (setq projectile-git-submodule-command nil)
  :config
  (projectile-mode +1)

  (defhydra hydra-projectile-other-window (:color teal)
    "projectile-other-window"
    ("f"  projectile-find-file-other-window        "file")
    ("g"  projectile-find-file-dwim-other-window   "file dwim")
    ("d"  projectile-find-dir-other-window         "dir")
    ("b"  projectile-switch-to-buffer-other-window "buffer")
    ("q"  nil                                      "cancel" :color blue))

  (defhydra hydra-projectile (:color teal
                              :hint nil)
"
     PROJECTILE: %(projectile-project-root)

     Find File            Search/Tags          Buffers                Cache
------------------------------------------------------------------------------------------
_s-f_: file            _a_: rg                _b_: switch to buffer  _c_: cache clear
 _ff_: file dwim       _h_: counsel           _K_: Kill all buffers  _x_: remove known project
  _r_: recent file                                                ^^^^_X_: cleanup non-existing
                                                                  ^^^^_z_: cache current
"
    ("a"   counsel-projectile-rg)
    ("b"   counsel-projectile-switch-to-buffer)
    ("c"   projectile-invalidate-cache)
    ("h"   counsel-projectile)
    ("s-f" counsel-projectile-find-file)
    ("ff"  counsel-projectile-find-file-dwim)
    ("i"   projectile-ibuffer)
    ("K"   projectile-kill-buffers)
    ("s-p" projectile-switch-project "switch project")
    ("p"   projectile-switch-project)
    ("s"   projectile-switch-project)
    ("r"   projectile-recentf)
    ("x"   projectile-remove-known-project)
    ("X"   projectile-cleanup-known-projects)
    ("z"   projectile-cache-current-file)
    ("`"   hydra-projectile-other-window/body "other window")
    ("q"   nil "cancel" :color blue))

  (global-set-key (kbd "C-> o") 'hydra-projectile/body))

(use-package counsel-projectile
  :ensure t
  :init
  (setq counsel-projectile-find-file-matcher 'ivy--re-filter)
  (setq counsel-projectile-sort-files nil)
  :config
  (counsel-projectile-mode))

(provide 'setup-projectile)
;;; setup-projectile.el ends here
