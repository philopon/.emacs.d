(require 'haskell-mode)
(require 'haskell-cabal)
(require 'inf-haskell)

;(defun kill-buffer-if-exists (bufname)
;  (let ((buf (get-buffer bufname)))
;    (when buf (kill-buffer) buf)
;    ))

(defun inf-cabal-dev-uniq-buffer-name (bufname)
  (if (get-buffer bufname)
      (loop for i from 1
          for name = (concat bufname "-" (number-to-string i))
          unless (get-buffer name) return name
          )
    bufname
  ))
; (inf-cabal-dev-uniq-buffer-name "test")
; (inf-cabal-dev-uniq-buffer-name "*scratch*")

(defun inf-cabal-dev-get-haskell-version ()
  (let* ((bufname (inf-cabal-dev-uniq-buffer-name "*haskell-version*"))
         (ret (call-process haskell-program-name nil bufname nil "--version"))
         (buf (get-buffer bufname))
         (result nil)
         )
    (when (= ret 0)
      (let (string begin end)
        (with-current-buffer buf
          (setq string (buffer-string))
          (setq begin (+ (string-match "version" string) 8))
          (end-of-line)
          (setq end (- (point) 2))
          (setq result (substring string begin end))
          )))
    (kill-buffer buf)
    result
    ))
; (inf-cabal-dev-get-haskell-version)

(defcustom inf-cabal-dev-package-subdir
  (concat "/cabal-dev/packages-" (inf-cabal-dev-get-haskell-version) ".conf")
  "cabal-dev-package subdirectory"
  )

(defcustom inf-cabal-dev-ghc-pkg-program-name "ghc-pkg" "ghc-pkg program name")


(defun inf-cabal-dev-get-package-conf (buf)
  (let ((root (inferior-haskell-find-project-root buf)))
    (when root
      (concat root inf-cabal-dev-package-subdir)
      )))

(defun inf-cabal-dev-packages-id-from-package-conf (&optional conf)
  (let* ((bufname (inf-cabal-dev-uniq-buffer-name "*ghc-pkg output*"))
         (ret     (if conf
                      (call-process inf-cabal-dev-ghc-pkg-program-name nil bufname nil
                                    "--verbose=2" (concat "--package-conf=" conf) "list")
                    (call-process inf-cabal-dev-ghc-pkg-program-name nil bufname nil
                                  "--verbose=2" "list")))
         (buf (get-buffer bufname))
         (result nil)
         )
    (when (= ret 0)
      (with-current-buffer buf
        (goto-char (point-max))
        (re-search-backward "using cache:")
        (re-search-forward ":" nil nil 2) (forward-char)
        (setq result
              (loop for i from (line-number-at-pos)
                    do (goto-line i) (end-of-line)
                    for eolpos = (point)
                    do (beginning-of-line)
                    while (re-search-forward "^    " eolpos t)
                    do (skip-chars-forward "^(" eolpos)
                    collect (buffer-substring (+ (point) 1) (- eolpos 1))
                    ))
        ))
    (kill-buffer buf)
    result
    ))
; (inf-cabal-dev-packages-id-from-package-conf)
; (inf-cabal-dev-packages-id-from-package-conf "/Users/philopon/src/yesod-platform-1.1.2/cabal-dev/packages-7.4.1.conf")

(defun inf-cabal-dev-split-package-id (id)
  (let* ((list (reverse (split-string id "-")))
         (hash (car list))
         (version (car (cdr list)))
         (name (apply 'concat (cdr (reverse (loop for s in (cdr (cdr list))
                                                  append (cons s (cons "-" nil))
                                                  )))))
         )
    (list name version hash)
    ))
; (inf-cabal-dev-split-package-id "bin-package-db-0.0.0.0-af08a1f9473d7bac1855916fdb29ba8c")

(defun inf-cabal-dev-build-depends (buf)
    (with-current-buffer buf
      (goto-char (point-min))
      (loop while (re-search-forward "build-depends:" nil t)
            collect (loop do (skip-chars-forward "[ \t\n]")
                          for start = (point)
                          do (skip-chars-forward "^[ \t\n]")
                          collect (buffer-substring-no-properties start (point))
                          do (skip-chars-forward "^,:") (forward-char)
                          until (= (char-before) ?:)))
      ))

; (inf-cabal-dev-unique-list (apply 'append (inf-cabal-dev-build-depends (find-file-noselect "/Users/philopon/src/yesod-platform-1.1.2/yesod-platform.cabal"))))


(defun inf-cabal-dev-unique-list (list)
  (loop for item in list
        unless (loop for e in result
                     thereis (string= e item)) collect item into result
        finally return result
        ))


(defun inf-cabal-dev-names-to-ids (names list)
  (let ((dict (mapcar (lambda (id) (cons
                                    (car (inf-cabal-dev-split-package-id id))
                                    id)) list))
        )
    (mapcar (lambda (name) (cdr (assoc name dict))) names)
    ))
; (inf-cabal-dev-names-to-ids (list "Cabal" "base") (inf-cabal-dev-packages-id-from-package-conf))

(defun inf-cabal-dev-get-package-name (buf)
  (with-current-buffer buf
    (substring-no-properties (concat (haskell-cabal-get-setting "name") "-" (haskell-cabal-get-setting "version")))
    ))

;(inf-cabal-dev-get-package-name (find-file-noselect "/Users/philopon/src/yesod-platform-1.1.2/yesod-platform.cabal"))

(defun inferior-cabal-dev-start-process ()
  (interactive)
  (let ((old (get-buffer-process inferior-haskell-buffer)))
    (when old (kill-process old)))
  (let* ((pkgcnf (inf-cabal-dev-get-package-conf (current-buffer)))
         (cabal (find-file-noselect (haskell-cabal-find-file)))
         (command (append (mapcar 'eval '(haskell-program-name
                                          (concat "-package-name " (inf-cabal-dev-get-package-name cabal))
                                          "-hide-all-packages"
                                          "-fbuilding-cabal-package"
                                          "-no-user-package-conf"
                                          (concat "-package-conf " pkgcnf)
                                          "-i -idist/build"
                                          "-i. -idist/build/autogen"
                                          "-Idist/build/autogen"
                                          "-Idist/build"
                                          "-optP-include -optPdist/build/autogen/cabal_macros.h"
                                          "-odir dist/build"
                                          "-hidir dist/build"
                                          "-stubdir dist/build"
                                          ))
                          (mapcar (lambda (i) (concat "-package-id " i))
                                  (inf-cabal-dev-names-to-ids
                                   (inf-cabal-dev-unique-list
                                    (apply 'append (inf-cabal-dev-build-depends cabal)))
                                   (append
                                    (inf-cabal-dev-packages-id-from-package-conf pkgcnf)
                                    (inf-cabal-dev-packages-id-from-package-conf)
                                    )
                                  ))
                          )))
    (inferior-haskell-start-process command)
    )
  )



(provide 'inf-cabal-dev)



