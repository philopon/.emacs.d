
(require 'inf-haskell)
(require 'haskell-cabal)
(require 'cl)

(defun inf-cabal-dev-uniq-buffer-name (bufname)
  (if (get-buffer bufname)
      (loop for i from 1
          for name = (concat bufname "-" (number-to-string i))
          unless (get-buffer name) return name
          )
    bufname
  ))

(defcustom fake-ghc-command
  (or (executable-find "fake-ghc-cabal-dev")
      (expand-file-name "~/.emacs.d/script/fake-ghc.py"))
  "fake ghc command")

(defun inf-cabal-dev-get-package-conf ()
  (when (haskell-cabal-find-dir)
    (concat (directory-file-name (haskell-cabal-find-dir))
            "/cabal-dev/cabal.config")))

(defun inf-cabal-dev-process-fake-ghc-output (buf)
  (with-current-buffer buf
    (goto-char (point-min))
    (loop for st = (re-search-forward "^== GHC Arguments: Start ==$" nil t)
          for ed = (re-search-forward "^== GHC Arguments: End ==$" nil t)
          while (and st ed)
          collect (let ((line (split-string
                               (buffer-substring-no-properties (+ st 1) (- ed 25))))
                        tmp result)
                    (while line
                      (setq tmp (car line))
                      (setq line (cdr line))
                      (while (and (car line) (/= (string-to-char (car line)) ?-))
                        (setq tmp (concat tmp " " (car line)))
                        (setq line (cdr line))
                        )
                      (setq result (cons tmp result))
                      )
                    (reverse (cdr result))
                    ))))

; (inf-cabal-dev-process-fake-ghc-output (get-buffer "*inf-cabal-dev*"))

(defun inf-cabal-dev-uniq-list (list)
  (let (result)
    (reverse (dolist (elem list result)
               (unless (member elem result) (setq result (cons elem result)))
               ))))

; (cons "--interactive" (delete "--make" (inf-cabal-dev-uniq-list (apply 'append (inf-cabal-dev-process-fake-ghc-output (get-buffer "*inf-cabal-dev*"))))))

(defun inf-cabal-dev-ghci-args ()
  (let ((old-pwd (file-name-directory (buffer-file-name)))
        (bufname (inf-cabal-dev-uniq-buffer-name "*inf-cabal-dev*"))
        pkg-conf result)
    (cd (file-name-directory (buffer-file-name)))
    (setq pkg-conf (inf-cabal-dev-get-package-conf))

    (cond
     (pkg-conf
      (cd (haskell-cabal-find-dir))
      (cond ((> (call-process "cabal" nil bufname nil
                              (concat "--config-file=" pkg-conf) "build" "--verbose=1"
                              (concat "--with-ghc=" fake-ghc-command)
                              ) 0)
             (message "cabal run failed."))
            (t
             (cd old-pwd)
             (setq result (delete "--make"
                                  (inf-cabal-dev-uniq-list
                                   (apply 'append
                                          (inf-cabal-dev-process-fake-ghc-output
                                           (get-buffer bufname))))))
             (kill-buffer (get-buffer bufname))
             result
             )
            )
      )
     (t (message "package.conf not found.")))))

(defun inf-cabal-dev-split-args (args)
  (apply 'append (mapcar (lambda (i) (split-string i " ")) args))
  )

(defun inferior-cabal-dev-start-process ()
  (interactive)
  (when (and inferior-haskell-buffer (get-buffer-process inferior-haskell-buffer))
    (message "inf-cabal-dev: kill process.")
    (kill-process (get-buffer-process inferior-haskell-buffer)))
  (message "inf-cabal-dev: start process.")
  (inferior-haskell-start-process
   (inf-cabal-dev-split-args (cons haskell-program-name (inf-cabal-dev-ghci-args))))
  (message "inf-cabal-dev: start process. done.")
  )


(provide 'inf-cabal-dev)


