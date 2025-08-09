;;; setup-prog-mode.el --- Set up language modes -*- lexical-binding: t; -*-
;;; Commentary:

;; This package installs programming related modes as well as setting
;; up LSP and copilot.

;;; Code:

;; Setting lsp-mode
(use-package lsp-mode
  :ensure t
  ;; uncomment to enable gopls http debug server
  ;; :custom (lsp-gopls-server-args '("-debug" "127.0.0.1:0"))
  :commands (lsp lsp-deferred)
  :config
  (progn
    ;; dynamically set python lsp environment
    ;; (setq lsp-python-ms-python-executable-cmd "pyright")
    (setq lsp-python-ms-python-executable-cmd
        (expand-file-name "venv/bin/python" (projectile-project-root)))

    ;; use flycheck, not flymake
    (setq lsp-prefer-flymake nil)
    )
  )

;; provides fancy overlay information
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (progn
    ;; disable inline documentation
    (setq lsp-ui-sideline-enable nil)
    ;; disable showing docs on hover at the top of the window
    (setq lsp-ui-doc-enable nil)
    )
  )

(use-package company
  :ensure t
  :hook ((prog-mode . company-mode)
         (prog-mode . display-line-numbers-mode))
  :config
  (progn
    ;; don't add any dely before trying to complete thing being typed
    ;; the call/response to gopls is asynchronous so this should have little
    ;; to no affect on edit latency
    (setq company-idle-delay 0.1)
    ;; start completing after a single character instead of 3
    (setq company-minimum-prefix-length 1)
    ;; align fields in completions
    (setq company-tooltip-align-annotations t)
    )
  )

;; copilot
;; Dependencies:
;; Install @github/copilot-language-server: M-x copilot-install-server
;; Login: M-x copilot-login
;; Check server status: M-x copilot-status
(use-package copilot
  :ensure t
  ;; :hook ((go-mode . copilot-mode)
  ;;        (python-mode . copilot-mode)
  ;;        (scala-mode . copilot-mode)
  ;;        )
  :bind (:map copilot-completion-map
          ("<tab>" . 'copilot-accept-completion)
          ("TAB" . 'copilot-accept-completion)
          ("C-TAB" . 'copilot-accept-completion-by-word)
          ("C-<tab>" . 'copilot-accept-completion-by-word)
          ("C-n" . 'copilot-next-completion)
          ("C-p" . 'copilot-previous-completion)
          )
  :config
    (add-to-list 'copilot-indentation-alist '(prog-mode 2))
    (add-to-list 'copilot-indentation-alist '(org-mode 2))
    (add-to-list 'copilot-indentation-alist '(text-mode 2))
    (add-to-list 'copilot-indentation-alist '(closure-mode 2))
    (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2))
  )

;; optional package to get the error squiggles as you edit
(use-package flycheck
  :ensure t
  :hook (prog-mode . flycheck-mode))

;; go-mode
;; Dependencies:
;; go install golang.org/x/tools/gopls@latest
(use-package go-mode
  :ensure t
  :bind (
         ;; If you want to switch existing go-mode bindings to use lsp-mode/gopls instead
         ;; uncomment the following lines
         ("C-c C-j" . lsp-find-definition)
         ("C-c C-d" . lsp-describe-thing-at-point)
         )
  :hook ((go-mode . lsp-deferred)
         (before-save . lsp-format-buffer)
         (before-save . lsp-organize-imports))
  :config
  (defhydra hydra-go-mode (:color teal
                           :hint nil)
"
     Playground                 Godef
---------------------------------------------------
 _p_: buffer                _d_: describe
 _P_: region to buffer      _j_: jump
 _s-p_: download entry      _J_: jump other window
"
    ("p"   go-play-buffer)
    ("P"   go-play-region)
    ("s-p" go-download-play)
    ("d"   godef-describe)
    ("j"   godef-jump)
    ("J"   godef-jump-other-window)
    ("q"   nil "cancel" :color blue))
  (define-key go-mode-map (kbd "C-c h") `hydra-go-mode/body)
  )

;; python-mode
;; Dependencies:
;; npm install -g pyright
(use-package python-mode
  :ensure t
  :hook ((python-mode . lsp-deferred)
         (before-save . lsp-format-buffer)
         (before-save . lsp-organize-imports))
  )

;; scala-mode
(use-package scala-mode
  :ensure t
  :mode "\\.s\\(cala\\|bt\\)$"
  :hook (scala-mode . lsp-deferred)
  )

(use-package lsp-metals
  :ensure t
  :after lsp-mode
  ;; :custom
  ;; (lsp-metals-server-command "~/.local/share/metals/metals") ;; or let lsp install it automatically
  )

;; org mode
(use-package org
  :ensure t
  :custom
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-startup-indented t)
  (org-startup-folded "showeverything")
  :hook (
         (org-mode . (lambda () (setq fill-column 120)))
         (org-mode . turn-on-auto-fill)
         (org-mode . visual-line-mode)
         )
  :config
  (define-key org-mode-map (kbd "RET") `org-return-indent)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((shell . t)
     (python . t)
     (ruby . t)
     (emacs-lisp . t)))
  )

;; swift
(use-package swift-mode
  :ensure t
  :mode "\\.swift\\'"
  :interpreter "swift")

;; terraform
(use-package terraform-mode
  :ensure t
  :defer t
  :config
  (add-hook 'terraform-mode-hook #'terraform-format-on-save-mode)
  )

;; yaml
(use-package yaml-mode
  :ensure t
  :defer t)

;; Markdown
(use-package markdown-mode
  :ensure t
  :custom
  (markdown-hide-urls t)
  :mode ("\\.md\\'" . markdown-mode)
  :hook
  (markdown-mode . visual-line-mode))

;; Rust
(use-package rust-mode
  :ensure t
  :bind (("C-c C-c" . rust-run))
  :custom
  (rust-format-on-save t)
  :mode ("\\.rs\\'" . rust-mode)
  )

;; protobuf
(use-package protobuf-mode
  :ensure t
  :defer t)

(provide 'setup-prog-mode)
