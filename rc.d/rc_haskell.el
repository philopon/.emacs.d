(use-package 'haskell-mode)

(defvar flymake-temp-directory "~/.emacs.tmp.d/flymake")

(defun flymake-create-temp-in-directory (file-name prefix)
  (unless (stringp file-name)
    (error "Invalid file-name"))
  (or prefix
      (setq prefix "flymake"))
  (unless (file-exists-p flymake-temp-directory) (make-directory flymake-temp-directory))
  (let* ((ext (file-name-extension file-name))
         (temp-name (file-truename
        	     (concat flymake-temp-directory "/"
                             (replace-regexp-in-string "/" "!" (file-name-sans-extension file-name))
        		     (and ext (concat "." ext))))))
    (flymake-log 3 "create-temp-in-directory: file=%s temp=%s" file-name temp-name)
    temp-name))

(defadvice ghc-flymake-init (around my-ghc-flymake-init activate)
  (setq ad-return-value
        (list ghc-module-command
              (ghc-flymake-command (flymake-init-create-temp-buffer-copy 'flymake-create-temp-in-directory)))))
  
(use-package 'ghc)

(setq ghc-flymake-command t)

(require 'rc_undo-tree)
(add-to-list 'undo-tree-incompatible-major-modes 'inferior-haskell-mode)

(add-hook 'haskell-mode-hook
          (lambda ()
            (turn-on-haskell-doc-mode)
            (turn-on-haskell-indentation)
            (ghc-init)
            (flymake-mode t)
            (define-key haskell-mode-map ghc-toggle-key nil)
            ))

(provide 'rc_haskell)

