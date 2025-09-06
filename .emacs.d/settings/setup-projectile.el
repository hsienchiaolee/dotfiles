(use-package projectile
  :ensure t
  :init
  (setq projectile-use-git-grep t)
  (setq projectile-enable-caching t)
  :config
  (projectile-global-mode t)
  
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
_s-f_: file            _a_: ag                _b_: switch to buffer  _c_: cache clear
 _ff_: file dwim       _g_: update gtags      _K_: Kill all buffers  _x_: remove known project
  _r_: recent fie                                                ^^^^_X_: cleanup non-existing
  _h_: helm                                                      ^^^^_z_: cache current
"
    ("a"   helm-projectile-rg)
    ("b"   helm-projectile-switch-to-buffer)
    ("c"   projectile-invalidate-cache)
    ("h"   counsel-projectile)
    ("s-f" counsel-projectile-find-file)
    ("ff"  counsel-projectile-find-file-dwim)
    ("g"   ggtags-update-tags)
    ("i"   projectile-ibuffer)
    ("K"   projectile-kill-buffers)
    ("s-p" projectile-switch-project "switch project")
    ("p"   projectile-switch-project)
    ("s"   projectile-switch-project)
    ("r"   helm-projectile-recentf)
    ("x"   projectile-remove-known-project)
    ("X"   projectile-cleanup-known-projects)
    ("z"   projectile-cache-current-file)
    ("`"   hydra-projectile-other-window/body "other window")
    ("q"   nil "cancel" :color blue))

  (global-set-key (kbd "C-> o") 'hydra-projectile/body)
  )

(use-package helm-projectile
  :ensure t
  )

(use-package counsel-projectile
  :ensure t
  :init
  (setq counsel-projectile-find-file-matcher 'ivy--re-filter)
  (setq counsel-projectile-sort-files nil)
  :config
  (counsel-projectile-mode)
  )


(provide 'setup-projectile)
