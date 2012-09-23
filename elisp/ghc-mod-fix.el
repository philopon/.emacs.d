(require 'inf-haskell)

(defun ghc-mod-sand-box-option (buf)
  (let ((root (inferior-haskell-find-project-root buf)))
    (when root `(,(concat "--sandbox=" root "/cabal-dev")))))

;; ghc-comp.el
(defadvice ghc-boot (before ghc-boot-overwrite)
  (defun ghc-boot (n)
    (if (not (ghc-which ghc-module-command))
        (message "%s not found" ghc-module-command)
      (ghc-read-lisp-list
       (lambda ()
         (message "Initializing...")
         (apply 'call-process ghc-module-command nil t nil
                `("-l" ,@(ghc-mod-sand-box-option (current-buffer)) "boot"))
         (message "Initializing...done"))
       n)))
  (ad-disable-advice 'ghc-boot 'before 'ghc-boot-overwrite)
  )
(ad-activate 'ghc-boot)

(defadvice ghc-load-modules (before ghc-load-modules-overwrite)
  (defun ghc-load-modules (mods)
    (if (not (ghc-which ghc-module-command))
        (message "%s not found" ghc-module-command)
      (ghc-read-lisp-list
       (lambda ()
         (message "Loading names...")
         (apply 'call-process ghc-module-command nil '(t nil) nil
                `(,@(ghc-make-ghc-options) "-l"
                  ,@(ghc-mod-sand-box-option (current-buffer))
                  "browse" ,@mods))
         (message "Loading names...done"))
       (length mods))))
  (ad-disable-advice 'ghc-load-modules 'before 'ghc-load-modules-overwrite)
  )
(ad-activate 'ghc-load-modules)

;; ghc-info.el
(defadvice ghc-type-obtain-tinfos (before ghc-type-obtain-tinfos-overwrite)
  (defun ghc-type-obtain-tinfos (modname)
    (let* ((ln (int-to-string (line-number-at-pos)))
           (cn (int-to-string (current-column)))
           (cdir default-directory)
           (file (buffer-file-name)))
      (ghc-read-lisp
       (lambda ()
         (cd cdir)
         (apply 'call-process ghc-module-command nil t nil
                `(,@(ghc-make-ghc-options) "-l" "type"
                  ,@(ghc-mod-sand-box-option (current-buffer))
                  ,file ,modname ,ln ,cn))
         (goto-char (point-min))
         (while (search-forward "[Char]" nil t)
           (replace-match "String"))))))
  (ad-disable-advice 'ghc-type-obtain-tinfos 'before 'ghc-type-obtain-tinfos-overwrite)
  )

(defadvice ghc-display-information (before ghc-display-information-overwrite)
  (defun ghc-display-information (cmds fontify)
    (interactive)
    (if (not (ghc-which ghc-module-command))
        (message "%s not found" ghc-module-command)
      (ghc-display
       fontify
       (lambda (cdir)
         (insert
          (with-temp-buffer
            (cd cdir)
            (apply 'call-process ghc-module-command nil t nil
                   `(,@(ghc-make-ghc-options)
                     ,@(ghc-mod-sand-box-option (current-buffer))
                     ,@cmds))
            (buffer-substring (point-min) (1- (point-max)))))))))
  (ad-disable-advice 'ghc-display-information 'before 'ghc-display-information-overwrite)
  )


(provide 'ghc-mod-fix)
