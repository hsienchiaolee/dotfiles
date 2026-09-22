;;; early-init.el --- Early startup settings -*- lexical-binding: t; -*-

;; Keep package diagnostics in *Warnings* without opening it automatically.
;; Older packages may omit binding cookies or compiler declarations.
(require 'warnings)
(add-to-list 'warning-suppress-types '(files missing-lexbind-cookie))
(setq native-comp-async-report-warnings-errors 'silent)

;; GCC can infer a nonexistent macOS target (18.0 on Darwin 27), causing
;; native compilation to fail.  Set the actual macOS version before package
;; activation starts compiler subprocesses, preserving an explicit override.
(when (and (eq system-type 'darwin)
           (not (getenv "MACOSX_DEPLOYMENT_TARGET")))
  (setenv "MACOSX_DEPLOYMENT_TARGET"
          (car (process-lines "/usr/bin/sw_vers" "-productVersion"))))

;;; early-init.el ends here
