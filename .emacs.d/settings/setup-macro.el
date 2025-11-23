;;; setup-macro.el --- Setup keyboard macros -*- lexical-binding: t; -*-
;;; Commentary:

;; Configuration for keyboard macros.

;;; Code:

(defun apply-named-macro-to-region-lines (top bottom)
  "Apply named keyboard macro to all lines in the region."
  (interactive "r")
  (let ((macro (intern
                (completing-read "kbd macro (name): "
                                 obarray
                                 (lambda (elt)
                                   (and (fboundp elt)
                                        (or (stringp (symbol-function elt))
                                            (vectorp (symbol-function elt))
                                            (get elt 'kmacro))))
                                 t))))
    (apply-macro-to-region-lines top bottom macro)))

(global-set-key (kbd "s-(") 'kmacro-start-macro)
(global-set-key (kbd "s-)") 'kmacro-end-macro)
(global-set-key (kbd "s-\\ a") 'apply-macro-to-region-lines)
(global-set-key (kbd "s-\\ s") 'name-last-kbd-macro)
(global-set-key (kbd "s-\\ n") 'apply-named-macro-to-region-lines)

(provide 'setup-macro)
;;; setup-macro.el ends here
