;;; setup-yasnippet.el --- Setup YASnippet -*- lexical-binding: t; -*-
;;; Commentary:

;; Configuration for YASnippet template system.

;;; Code:

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1)

  (defhydra hydra-yasnippet (:color teal :hint nil)
"
               YASnippets
  
  Modes        Load/Visit        Actions
--------------------------------------------
 _g_: global     _d_: directory     _i_: insert
 _m_: minor      _f_: file          _e_: expand
 _E_: extra      _l_: list          _t_: tryout
               _a_: reload        _n_: new
"
    ("d" yas-load-directory)
    ("e" yas-expand)
    ("E" yas-activate-extra-mode)
    ("i" yas-insert-snippet)
    ("f" yas-visit-snippet-file)
    ("n" yas-new-snippet)
    ("t" yas-tryout-snippet)
    ("l" yas-describe-tables)
    ("g" yas/global-mode)
    ("m" yas/minor-mode)
    ("a" yas-reload-all))
  (define-key yas-minor-mode-map (kbd "C-c y") 'hydra-yasnippet/body))

(provide 'setup-yasnippet)
;;; setup-yasnippet.el ends here
