;;; setup-magit.el --- Setup Magit -*- lexical-binding: t; -*-
;;; Commentary:

;; Configuration for Magit git interface.

;;; Code:

(use-package magit
  :ensure t
  :demand
  :init
  (setq magit-auto-revert-mode nil)
  :config
  (defhydra hydra-magit (:color teal :hint nil)
"
                   Magit

  Status        Changes           Rebase            Cherry Pick       Merge
--------------------------------------------------------------------------------------
_s_: status      _c_: commit        _r_: rebase          _p_: cherry pick    _m_: merge
_d_: diff        _h_: reset         _s-r_: continue      _s-p_: continue
_l_: log         _H_: reset hard
_f_: reflog

"
    ("s" magit-status)
    ("d" magit-diff)
    ("l" magit-log-current)
    ("f" magit-reflog)
    ("c" magit-commit)
    ("h" magit-reset-head)
    ("H" magit-reset-hard)
    ("r" magit-rebase)
    ("s-r" magit-rebase-continue)
    ("p" magit-cherry-pick)
    ("s-p" magit-sequencer-continue)
    ("m" magit-merge)
    ("q" nil "cancel" :color blue)
    ("RET" magit-visit-thing))
  (global-set-key (kbd "s-m") 'hydra-magit/body))

(provide 'setup-magit)
;;; setup-magit.el ends here
