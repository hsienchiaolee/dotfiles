;;; early-init.el --- Early startup settings -*- lexical-binding: t; -*-

;; GCC can infer a nonexistent macOS target (18.0 on Darwin 27), causing
;; native compilation to fail.  Set the actual macOS version before package
;; activation starts compiler subprocesses, preserving an explicit override.
(when (and (eq system-type 'darwin)
           (not (getenv "MACOSX_DEPLOYMENT_TARGET")))
  (setenv "MACOSX_DEPLOYMENT_TARGET"
          (car (process-lines "/usr/bin/sw_vers" "-productVersion"))))

;;; early-init.el ends here
