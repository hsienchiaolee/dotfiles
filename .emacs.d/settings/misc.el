;;; misc.el --- Miscellaneous settings -*- lexical-binding: t; -*-
;;; Commentary:

;; Miscellaneous Emacs settings and package configurations.

;;; Code:

;; Emacs Settings
(setq ring-bell-function 'ignore)
(setq inhibit-startup-screen t)
(setq dired-listing-switches "-alh")
(defalias 'yes-or-no-p 'y-or-n-p)
(delete-selection-mode 1)

;; auto complete
(setq-default completion-ignore-case t)
(setq-default pcomplete-ignore-case t)

;; disable shell echo
(setq comint-process-echoes t)
(put 'erase-buffer 'disabled nil)

;; vagrant-tramp
(use-package vagrant-tramp
  :ensure t)

;; ansible vault
(use-package ansible-vault
  :ensure t
  :pin melpa-stable
  :config
  ;; Initialize vault-id variable to prevent "void variable" error
  (defvar-local ansible-vault--vault-id nil)

  ;; Fix: Expand relative password file paths from ansible.cfg
  (defun ansible-vault--process-config-files ()
    "Locate vault_password_file definitions in ansible config files.

Expands relative paths to absolute paths relative to ansible.cfg location."
    (let ((config-file
           (seq-find (lambda (file) (and file (file-readable-p file) file))
                     (list (getenv "ANSIBLE_CONFIG")
                           (expand-file-name "ansible.cfg"
                                             (locate-dominating-file buffer-file-name "ansible.cfg"))
                           "~/.ansible.cfg"
                           "/etc/ansible/ansible.cfg"))))
      (unless (= (length config-file) 0)
        (with-temp-buffer
          (insert-file-contents config-file)
          (let ((content (buffer-string)))
            (when (string-match
                   (rx line-start "vault_password_file"
                       (zero-or-more blank) "=" (zero-or-more blank)
                       (group (minimal-match (one-or-more not-newline)))
                       (zero-or-more blank) (zero-or-more ";" (zero-or-more not-newline))
                       line-end) content)
              (let ((password-file (match-string 1 content)))
                (if (file-name-absolute-p password-file)
                    password-file
                  (expand-file-name password-file (file-name-directory config-file))))))))))

  ;; Automatically send ansible vault passwords invisibly
  (setq comint-password-prompt-regexp
        (concat comint-password-prompt-regexp
                "\\|^Vault password:\\s *\\'")))

;; dirtrack
(add-hook 'shell-mode-hook
          (lambda ()
            ;; Disable shell-dirtrack-mode and customize with dirtrack-mode
            (shell-dirtrack-mode 0)
                                        ;(setq ssh-directory-tracking-mode 'ftp)
            ;; Custom dirtrack-mode for PS1: time user@host:/dir(branch)$
            (setq-local dirtrack-list
                        '("^\\(?:([^)]*) *\\)?[0-9:]+ [^@]+@[^:]+:\\(.*?\\)\\(([^)]*)\\)?\\$ " 1))
            (dirtrack-mode 1)
                                        ;(dirtrack-debug-mode)
            ))

(provide 'misc)
;;; misc.el ends here
