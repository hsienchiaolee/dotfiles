;;; utils.el --- Utility functions -*- lexical-binding: t; -*-
;;; Commentary:

;; Utility functions and key bindings.

;;; Code:

;; eval-and-replace
(defun eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))
(global-set-key (kbd "C-c C-e") 'eval-and-replace)

;; replace string
(global-set-key (kbd "M-s-f") 'replace-string)

;; duplicate line
(defun duplicate-line ()
  "Duplicate the current line."
  (interactive)
  (let ((text (buffer-substring (line-beginning-position) (line-end-position))))
    (move-end-of-line 1)
    (newline)
    (insert text)))
(global-set-key (kbd "s-p") 'duplicate-line)

(use-package expand-region
  :ensure t
  :bind ("C-@" . er/expand-region))

(provide 'utils)
;;; utils.el ends here
