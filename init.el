
(add-to-list 'load-path "~/.emacs.d/elisp")

(defun config-load (filename)
  (load (concat "~/.emacs.d/config.d/" filename))
)

(config-load "global.el")
(config-load "package.el")

(config-load "undo.el")
(config-load "anything.el")
(config-load "auto-complete.el")

