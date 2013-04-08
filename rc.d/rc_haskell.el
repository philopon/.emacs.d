; haskell-mode-autoloads ghc-autoloads ghci-completion-autoloads

(use-package 'haskell-mode)

(use-package 'ghc)

(setq ghc-flymake-command t)

(add-hook 'haskell-mode-hook
          (lambda ()
            (turn-on-haskell-doc-mode)
            (turn-on-haskell-indentation)
            (flymake-mode t)
            (ghc-init)
            (define-key haskell-mode-map ghc-toggle-key nil)
            ))


(provide 'rc_haskell)

