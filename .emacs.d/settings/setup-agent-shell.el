;;; setup-agent-shell.el --- Agent-shell with companion packages -*- lexical-binding: t; -*-
;;; Commentary:

;; ACP-based agent-agnostic shell (Claude, Codex, Hermes)
;; with dashboard, attention tracking, bookmarks, and register helpers.

;;; Code:

(require 'subr-x)

(declare-function agent-shell-project-buffers "agent-shell")
(defvar agent-shell-buffer-name-format)

(defun my-agent-shell--new-label ()
  "Return a label for a new agent shell in the current project."
  (require 'agent-shell)
  (if (agent-shell-project-buffers)
      (let ((label "")
            (prompt "Agent label: "))
        (while (string-empty-p label)
          (setq label (string-trim (read-string prompt))
                prompt "Agent label cannot be empty; try again: "))
        label)
    "default"))

(defun my-agent-shell--start-labeled (start-function)
  "Call START-FUNCTION with a human-readable label."
  (let* ((label (my-agent-shell--new-label))
         (agent-shell-buffer-name-format
          (lambda (agent-name project-name)
            (format "%s Agent @ %s: %s"
                    agent-name project-name label))))
    (call-interactively start-function)))

(defhydra hydra-agent-shell (:color teal :hint nil)
"
     AGENT SHELL

     Start             Navigate          Send To           Quick Send
---------------------------------------------------------------------------
_s_: start/reuse     _t_: toggle        _d_: context      _R_: region
_a_: new agent       _j_: attention     _r_: region to    _F_: file
_c_: new claude      _m_: manager       _f_: file to      _I_: clip image
_x_: new codex                         _i_: clip image to _G_: screenshot
_w_: new worktree                      _g_: screenshot to
_e_: new hermes

     Compose / Inspect
---------------------------
_p_: compose prompt    _T_: transcript
_h_: command menu      _v_: traffic logs
_l_: toggle logging    _q_: cancel
"
  ("s" agent-shell)
  ("a" (my-agent-shell--start-labeled #'agent-shell-new-shell))
  ("c" (my-agent-shell--start-labeled #'agent-shell-anthropic-start-claude-code))
  ("x" (my-agent-shell--start-labeled #'agent-shell-openai-start-codex))
  ("e" (my-agent-shell--start-labeled #'agent-shell-hermes-start-agent))
  ("w" agent-shell-new-worktree-shell)

  ("t" agent-shell-toggle)
  ("j" agent-shell-attention-jump)
  ("m" agent-shell-manager-toggle)

  ("d" agent-shell-send-dwim)
  ("r" agent-shell-send-region-to)
  ("f" agent-shell-send-file-to)
  ("i" agent-shell-send-clipboard-image-to)
  ("g" agent-shell-send-screenshot-to)

  ("R" agent-shell-send-region)
  ("F" agent-shell-send-file)
  ("I" agent-shell-send-clipboard-image)
  ("G" agent-shell-send-screenshot)

  ("p" agent-shell-prompt-compose)
  ("T" agent-shell-open-transcript)
  ("h" agent-shell-help-menu)
  ("v" agent-shell-view-traffic)
  ("l" agent-shell-toggle-logging)

  ("q" nil "cancel" :color blue))

(autoload 'agent-shell-anthropic-start-claude-code "agent-shell-anthropic" nil t)
(autoload 'agent-shell-openai-start-codex "agent-shell-openai" nil t)
(autoload 'agent-shell-hermes-start-agent "agent-shell-hermes" nil t)

(use-package agent-shell
  :ensure t
  :ensure-system-package
  ((claude . "brew install claude")
   (codex . "brew install codex")
   (codex-acp . "brew install codex-acp")
   (hermes . "brew install hermes-agent")
   (claude-agent-acp . "npm install -g @agentclientprotocol/claude-agent-acp"))
  :bind ("C-c a" . hydra-agent-shell/body)
  :custom
  ;; GUI Emacs may not inherit Homebrew's PATH.
  (agent-shell-hermes-acp-command
   (list (or (executable-find "hermes")
             (if (file-executable-p "/opt/homebrew/bin/hermes")
                 "/opt/homebrew/bin/hermes"
               "/usr/local/bin/hermes"))
         "acp"))
  (agent-shell-cwd-function (lambda () default-directory))
  (agent-shell-preferred-agent-config 'codex)
  (agent-shell-prefer-session-resume nil)
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
