(require 'myfunctions)

;; haskell-mode
(install-if-not-exists 'haskell-mode)
(load "haskell-site-file")

;; inf-cabal-dev
(autoload 'inferior-cabal-dev-start-process "inf-cabal-dev")

;; ghc-mod
(autoload 'ghc-init "ghc" nil t)


;; auto-complete
(when (require 'auto-complete nil t)
  (ac-define-source ghc-mod-period
    '((depends ghc)
      (candidates . (ghc-select-completion-symbol))
      (symbol . "s")
      (prefix . "\\.\\(.*\\)")
      (cache))
    )
  )

;; hook
(defun my-haskell-mode-hook ()
  ;; haskell-mode
  (when (package-installed-p 'haskell-mode)
    (turn-on-haskell-doc-mode)
    (turn-on-haskell-indentation)
    )

  ;; ghc-mod
  (when (executable-find "ghc-mod")
    (require 'ghc-mod-fix)
    (ghc-init)
    (flymake-mode)
    (ghc-flymake-toggle-command)
    (when (require 'auto-complete nil t)
      (add-to-list 'ac-sources 'ac-source-ghc-mod)
      (add-to-list 'ac-sources 'ac-source-ghc-mod-period)
      )
    )
  ;; keymap
  (define-key haskell-mode-map (kbd "C-c C-c") 'inferior-cabal-dev-start-process)
  )

(add-hook 'haskell-mode-hook 'my-haskell-mode-hook)

