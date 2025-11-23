;;; setup-indents.el --- Setup indentation -*- lexical-binding: t; -*-
;;; Commentary:

;; Configuration for indentation settings across languages.

;;; Code:

(setq-default indent-tabs-mode nil)

(setq-default c-basic-offset 2)
(setq-default css-indent-offset 2)
(setq-default javascript-indent-level 2)
(setq-default js-indent-level 2)
(setq-default js2-basic-offset 2)
(setq-default scala-indent-level 2)
(setq-default sh-basic-offset 2)
(setq-default sh-indentation 2)
(setq-default tab-width 2)

(provide 'setup-indents)
;;; setup-indents.el ends here
