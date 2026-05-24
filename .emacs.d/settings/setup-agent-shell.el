;;; setup-agent-shell.el --- Agent-shell with companion packages -*- lexical-binding: t; -*-
;;; Commentary:

;; ACP-based agent-agnostic shell (Claude, Codex)
;; with dashboard, attention tracking, bookmarks, and register helpers.

;;; Code:

(defhydra hydra-agent-shell (:color teal :hint nil)
"
     AGENT SHELL

     New               Manage
---------------------------------------------------
_a_: new agent       _m_: manager dashboard
_c_: new claude
_x_: new codex
"
  ("a" agent-shell-new-shell)
  ("c" agent-shell-anthropic-start-claude-code)
  ("x" agent-shell-openai-start-codex)
  ("m" agent-shell-manager-toggle)
  ("q" nil "cancel" :color blue))

(use-package agent-shell
  :ensure t
  :ensure-system-package
  ((claude . "brew install claude")
   (codex . "brew install codex")
   (codex-acp . "brew install codex-acp")
   (claude-agent-acp . "npm install -g @anthropic-ai/claude-agent-acp"))
  :bind ("C-c a" . hydra-agent-shell/body)
  :custom
  (agent-shell-cwd-function (lambda () default-directory))
  (agent-shell-preferred-agent-config 'codex)
  (agent-shell-header-style 'text)
  (agent-shell-show-welcome-message nil)
  (agent-shell-show-context-usage-indicator 'detailed))

;; dashboard for managing multiple agent instances
(use-package agent-shell-manager
  :vc (:url "https://github.com/jethrokuan/agent-shell-manager" :rev :newest)
  :after agent-shell)

;; mode-line indicator for agents needing attention
(use-package agent-shell-attention
  :vc (:url "https://github.com/ultronozm/agent-shell-attention.el" :rev :newest)
  :after agent-shell
  :hook (agent-shell-mode . agent-shell-attention-mode))

;; bookmark agent sessions for persistence across restarts
(use-package agent-shell-bookmark
  :vc (:url "https://github.com/dcluna/agent-shell-bookmark" :rev :newest)
  :after agent-shell)

(provide 'setup-agent-shell)
;;; setup-agent-shell.el ends here
