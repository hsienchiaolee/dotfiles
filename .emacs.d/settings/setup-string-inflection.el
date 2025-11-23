;;; setup-string-inflection.el --- Setup string inflection -*- lexical-binding: t; -*-
;;; Commentary:

;; Configuration for string case conversion utilities.

;;; Code:

(use-package string-inflection
  :ensure t
  :config 
  (defhydra hydra-string-inflection (:color teal
                                     :hint nil)
"
     String Inflection
---------------------------------------------------
 _c_: Lower Camel Case    _s_: Lower Snake Case    _k_: Kebab Case
 _C_: Upper Camel Case    _S_: Upper Snake Case    _j_: Json Pretty Print

"
    ("c" string-inflection-lower-camelcase)
    ("C" string-inflection-camelcase)
    ("s" string-inflection-underscore)
    ("S" string-inflection-upcase)
    ("k" string-inflection-kebab-case)
    ("j" json-pretty-print)
    ("q" nil "cancel" :color blue))

  (global-set-key (kbd "C-> c") 'hydra-string-inflection/body))

(provide 'setup-string-inflection)
;;; setup-string-inflection.el ends here
