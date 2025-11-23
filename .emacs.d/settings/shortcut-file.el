;;; shortcut-file.el --- File shortcuts -*- lexical-binding: t; -*-
;;; Commentary:

;; Quick shortcuts to commonly accessed files.

;;; Code:

(defhydra hydra-file-shortcuts (:color teal
                                :columns 4)
  "files"
  ("s" (switch-to-buffer "*scratch*") "scratch" :exit t)
  ("e" (find-file "~/Library/Preferences/Aquamacs Emacs/Preferences.el") ".emacs" :exit t)
  ("b" (find-file "~/.bash/interactive") "bashrc" :exit t)
  ("o" (find-file "~/Documents/org") "notes" :exit t)
  ("c" (find-file "~/.ssh/config") "SSH Config" :exit t)
  ("d" (find-file "~/d") "tmp" :exit t)
  ("q" nil "quit" :color blue))
(global-set-key (kbd "s-/") 'hydra-file-shortcuts/body)

(provide 'shortcut-file)
;;; shortcut-file.el ends here
