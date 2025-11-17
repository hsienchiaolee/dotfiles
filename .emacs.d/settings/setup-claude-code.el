;;; setup-claude-code.el --- Set up Claude Code integration -*- lexical-binding: t; -*-
;;; Commentary:

;; This package installs packages to integration Claude Code into Emacs

;;; Code:

;; install required inheritenv dependency:
(use-package inheritenv
  :vc (:url "https://github.com/purcell/inheritenv" :rev :newest))

;; for vterm terminal backend:
(use-package vterm
  :ensure t)

;; monet to allow claude code to interact with emacs
(use-package monet
  :vc (:url "https://github.com/stevemolitor/monet" :rev :newest))

;; install claude-code.el
(use-package claude-code
  :ensure t
  :vc (:url "https://github.com/stevemolitor/claude-code.el" :rev :newest)
  :config  
  (add-hook 'claude-code-process-environment-functions #'monet-start-server-function)
  (monet-mode 1)
  
  (setq claude-code-terminal-backend 'vterm)
  (claude-code-mode)
  
  :bind-keymap ("C-c c" . claude-code-command-map)

  ;; Optionally define a repeat map so that "M" will cycle thru Claude auto-accept/plan/confirm modes after invoking claude-code-cycle-mode / C-c M.
  :bind
  (:repeat-map my-claude-code-map ("M" . claude-code-cycle-mode)))

(provide 'setup-claude-code)
