; haskell-mode-autoloads ghc-autoloads ghci-completion-autoloads

(use-package 'haskell-mode)

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(use-package 'ghc)

(setq ghc-flymake-command t)

(add-hook 'haskell-mode-hook
          (lambda ()
            (flymake-mode t)
            (ghc-init)
            (define-key haskell-mode-map ghc-toggle-key nil)
            ))


(provide 'rc_haskell)

