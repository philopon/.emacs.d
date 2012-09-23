
(add-to-list 'load-path "~/.emacs.d/elisp")

(require 'myfunctions)
(setq exec-path (append (get-path-from-environment-plist) exec-path))

(setenv "PATH" (exec-path-to-env exec-path))

(defun config-load (filename)
  (load (concat "~/.emacs.d/config.d/" filename))
)

(config-load "global.el")
(config-load "package.el")

(config-load "undo.el")
(config-load "anything.el")
(config-load "auto-complete.el")

