(when (< emacs-major-version 27)
  (package-initialize))

;; Set path to dependencies
(setq settings-dir (expand-file-name "settings" user-emacs-directory))
(add-to-list 'load-path settings-dir)

;; setup interface and install packages early
(require 'setup-interface)
(require 'setup-package)
(require 'setup-theme)
(require 'setup-tramp)

(require 'setup-helm)
(require 'setup-indents)
(require 'setup-ivy)
(require 'setup-macro)
(require 'setup-magit)
(require 'setup-multiple-cursors)
(require 'setup-navigation)
(require 'setup-projectile)
(require 'setup-string-inflection)
(require 'setup-yasnippet)
(require 'setup-prog-mode)
(require 'shortcut-file)
(require 'shortcut-shell)
(require 'shortcut-timestamp)

(require 'setup-claude-code)

(require 'misc)
(require 'utils)

;; start server
(server-start)
