;;; setup-native-comp-environment.el --- Scope Emacs' bundled compiler libs -*- lexical-binding: t; -*-

(require 'cl-lib)

(defun setup-native-comp-environment--bundled-roots ()
  "Return this Emacs bundle's libgccjit directories."
  (let ((prefix (file-name-as-directory (expand-file-name invocation-directory))))
    (when (file-directory-p prefix)
      (delq nil
            (mapcar
             (lambda (directory)
               (let ((libgccjit (expand-file-name "libgccjit" directory)))
                 (and (file-directory-p libgccjit)
                      (file-name-as-directory libgccjit))))
             (directory-files prefix t "\\`lib-[^/]+\\'" t))))))

(defun setup-native-comp-environment--bundled-path-p (path roots)
  "Return non-nil when PATH is ROOT or below one of ROOTS."
  (let ((path (file-name-as-directory (expand-file-name path))))
    (cl-some (lambda (root) (string-prefix-p root path)) roots)))

(defun setup-native-comp-environment ()
  "Move this Emacs bundle's compiler paths from LIBRARY_PATH to native-comp."
  (when (and (eq system-type 'darwin)
             (getenv "LIBRARY_PATH"))
    (let ((roots (setup-native-comp-environment--bundled-roots)))
      (when roots
        (require 'comp)
        (let ((entries (split-string (getenv "LIBRARY_PATH") path-separator nil))
              (kept nil)
              (moved nil))
          (dolist (entry entries)
            (if (and entry
                     (not (string= entry ""))
                     (setup-native-comp-environment--bundled-path-p entry roots))
                (progn
                  (push entry moved))
              (push entry kept)))
          (setq kept (nreverse kept)
                moved (nreverse moved))
          (if kept
              (setenv "LIBRARY_PATH" (mapconcat #'identity kept path-separator))
            (setenv "LIBRARY_PATH" nil))
          (dolist (entry moved)
            (let ((option (concat "-L" entry)))
              (unless (member option native-comp-driver-options)
                (setq native-comp-driver-options
                      (append native-comp-driver-options (list option)))))))))))

(when (eq system-type 'darwin)
  (setup-native-comp-environment))

(provide 'setup-native-comp-environment)

;;; setup-native-comp-environment.el ends here
