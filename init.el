
(add-to-list 'load-path "~/src/ghc-mod-1.11.0/cabal-dev/share/ghc-mod-1.11.0")
(add-to-list 'load-path "~/src/ghc-mod-1.11.0/cabal-dev/share/ghc-7.4.1/ghc-mod-1.11.0")
(add-to-list 'load-path "~/.emacs.d/elisp")

(require 'myfunctions)
(when (file-exists-p "~/.MacOSX/environment.plist")
  (setq exec-path (append (get-path-from-environment-plist) exec-path)))

(setenv "PATH" (exec-path-to-env exec-path))

(defun config-load (filename)
  (load (concat "~/.emacs.d/config.d/" filename))
)

(config-load "global.el")
(config-load "package.el")

(config-load "undo.el")
(config-load "helm.el")
(config-load "auto-complete.el")
(config-load "haskell.el")

