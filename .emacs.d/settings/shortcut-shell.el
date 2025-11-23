;;; shortcut-shell.el --- Shell shortcuts -*- lexical-binding: t; -*-
;;; Commentary:

;; Quick access to multiple shell buffers with keybindings.

;;; Code:

(add-to-list 'display-buffer-alist
             '("^\\*shell\\*$" . (display-buffer-same-window)))

(defun shell-named (name)
  "Open a shell and rename it to NAME."
  (shell)
  (rename-buffer name)
  (set-process-query-on-exit-flag (get-buffer-process name) nil))

(defmacro hot-shell (name)
  `(lambda () (interactive)
     (if (get-buffer ,name) (switch-to-buffer ,name)
       (shell-named ,name))))

(defun remote-shell-named (name)
  "Open a remote shell and rename it to NAME."
  (interactive)
  (better-shell-remote-open)
  (rename-buffer name)
  (set-process-query-on-exit-flag (get-buffer-process name) nil))

(defmacro remote-hot-shell (name)
  `(lambda () (interactive)
     (if (get-buffer ,name) (switch-to-buffer ,name)
       (remote-shell-named ,name))))

(global-set-key (kbd "M-1") (hot-shell "*shell1*"))
(global-set-key (kbd "M-2") (hot-shell "*shell2*"))
(global-set-key (kbd "M-3") (hot-shell "*shell3*"))
(global-set-key (kbd "M-4") (hot-shell "*shell4*"))
(global-set-key (kbd "M-5") (hot-shell "*shell5*"))
(global-set-key (kbd "M-6") (hot-shell "*shell6*"))
(global-set-key (kbd "M-7") (hot-shell "*shell7*"))
(global-set-key (kbd "M-8") (hot-shell "*shell8*"))
(global-set-key (kbd "M-9") (hot-shell "*shell9*"))
(global-set-key (kbd "M-0") (hot-shell "*shell0*"))

;; Setup Shell
(custom-set-variables
 ;; '(tramp-default-method "ssh")         ; uses ControlMaster
 '(comint-scroll-to-bottom-on-input t)    ; always insert at the bottom
 '(comint-scroll-to-bottom-on-output nil) ; always add output at the bottom
 '(comint-scroll-show-maximum-output t)   ; scroll to show max possible output
 ;; '(comint-completion-autolist t)       ; show completion list when ambiguous
 '(comint-input-ignoredups t)             ; no duplicates in command history
 ;; '(comint-completion-addsuffix t)      ; insert space/slash after file completion
 '(comint-buffer-maximum-size 20000)      ; max length of the buffer in lines
 '(comint-prompt-read-only nil)           ; if this is t, it breaks shell-command
 '(comint-get-old-input (lambda () ""))   ; what to run when i press enter on a
                                        ; line above the current prompt
 '(comint-input-ring-size 5000)         ; max shell history size
 '(protect-buffer-bury-p nil)
 )
;; truncate buffers continuously
(add-hook 'comint-output-filter-functions 'comint-truncate-buffer)

(use-package better-shell
  :ensure t
  :config
  (defhydra hydra-better-shell (:color teal :hint nil)
"
  Better Shell
----------------
_r_: remote       
_s_: sudo       
_p_: projectile
_X_: close connections
"
    ("r" better-shell-remote-open)
    ("s" better-shell-sudo-here)
    ("p" better-shell-for-projectile-root)
    ("X" tramp-cleanup-all-connections)
    ("q" nil "cancel" :color blue)
    )
  (global-set-key (kbd "C-> s") 'hydra-better-shell/body))

(provide 'shortcut-shell)
;;; shortcut-shell.el ends here
