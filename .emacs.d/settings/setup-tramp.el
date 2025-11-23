;;; setup-tramp.el --- Setup TRAMP -*- lexical-binding: t; -*-
;;; Commentary:

;; Configuration for TRAMP remote file editing.

;;; Code:

(use-package tramp
  :ensure nil
  :defer t
  :init
  (setq tramp-default-method "sshx")
  (set-default 'tramp-default-proxies-alist '((".*" "\\`root\\'" "/ssh:%h:")))
  :config
  ;; Faster backup handling (disable versioned backups remotely)
  (setq tramp-backup-directory-alist backup-directory-alist)
  (setq tramp-auto-save-directory temporary-file-directory)

  ;; Fix performance issues with remote shell prompts
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

(provide 'setup-tramp)
;;; setup-tramp.el ends here
