;;; setup-kubernetes.el --- Setup Kubernetes -*- lexical-binding: t; -*-
;;; Commentary:

;; Configuration for Kubernetes integration.

;;; Code:

(use-package kubernetes
  :ensure t
  :commands (kubernetes-overview))

(provide 'setup-kubernetes)
;;; setup-kubernetes.el ends here
