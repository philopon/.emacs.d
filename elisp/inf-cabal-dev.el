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
    (if root
        (concat root inf-cabal-dev-package-subdir)
      (concat (haskell-cabal-find-dir) inf-cabal-dev-package-subdir)
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
        (goto-char (point-min))
        (re-search-forward "^    " nil t)
        (setq result
              (loop for i from (line-number-at-pos)
                    do (goto-line i)
                    for startpos = (point)
                    do (end-of-line) (skip-chars-backward ")}")
                    for endpos   = (point)

                    do (re-search-backward "(" startpos t)
                    for begin  = (point)
                    do (beginning-of-line)
                    while (re-search-forward "^    " endpos t)
                    collect (buffer-substring (+ begin 1) endpos)
                    ))
        ))
    (kill-buffer buf)
    result
    ))

; (inf-cabal-dev-packages-id-from-package-conf "/Users/philopon/src/yesod-platform-1.1.2/cabal-dev/packages-7.4.1.conf")

; (inf-cabal-dev-packages-id-from-package-conf "/Users/philopon/src/test/cabal-dev/packages-7.4.1.conf")

(defun inf-cabal-dev-split-package-id (id)
  (let ((list (reverse (split-string id "-"))))
    (if (>= (length list) 3)
        (let* ((hash (car list))
               (version (car (cdr list)))
               (name (apply 'concat (cdr (reverse (loop for s in (cdr (cdr list))
                                                        append (cons s (cons "-" nil))
                                                        )))))
               )
          (list name version hash)
          )
      (list id)
    )))
; (inf-cabal-dev-split-package-id "parallel-3.2.0.2-98167199466a568a2378238fd9230cf9")
; (inf-cabal-dev-split-package-id "bin-package-db-0.0.0.0-af08a1f9473d7bac1855916fdb29ba8c")
; (inf-cabal-dev-split-package-id "builtin_rts")

(split-string "builtin_rts" "-")

(defun inf-cabal-dev-get-section (target buf)
    (with-current-buffer buf
      (goto-char (point-min))
      (loop while (re-search-forward target nil t)
            collect (loop do (skip-chars-forward "[ \t\n]")
                          for start = (point)
                          do (skip-chars-forward "^[ \t\n]")
                          collect (buffer-substring-no-properties start (point))
                          do (skip-chars-forward "^,:")
                          until (eobp)
                          until (= (char-after) ?:)
                          do (forward-char)
                          ))
      ))

; (inf-cabal-dev-unique-list (apply 'append (inf-cabal-dev-get-section "build-depends:" (find-file-noselect "/Users/philopon/src/yesod-platform-1.1.2/yesod-platform.cabal"))))
; (inf-cabal-dev-get-section "extensions:" (find-file-noselect "/Users/philopon/src/yesod-platform-1.1.2/yesod-platform.cabal"))

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
    (loop for i in (mapcar (lambda (name) (cdr (assoc name dict))) names)
          when i collect i
          )))

; (inf-cabal-dev-names-to-ids (list "Cabal" "base" "ghc") (inf-cabal-dev-packages-id-from-package-conf))

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
         (cabal  (find-file-noselect (haskell-cabal-find-file)))
         (dict   (append
                  (inf-cabal-dev-packages-id-from-package-conf pkgcnf)
                  (inf-cabal-dev-packages-id-from-package-conf)
                  ))
         (pkgs   (inf-cabal-dev-unique-list
                  (apply 'append (inf-cabal-dev-get-section "build-depends:" cabal))))
         (ext   (inf-cabal-dev-unique-list
                 (apply 'append (inf-cabal-dev-get-section "extensions:" cabal))))
         (command (append (mapcar 'eval '(haskell-program-name
                                          (concat "-package-name " (inf-cabal-dev-get-package-name cabal))
                                          "-hide-all-packages"
                                          "-fbuilding-cabal-package"
                                          "-no-user-package-conf"
                                          (concat "-package-conf " pkgcnf)
                                          ))
                          (mapcar (lambda (i) (concat "-package-id " i))
                                  (inf-cabal-dev-names-to-ids
                                   pkgs
                                   dict
                                  ))
                          (mapcar (lambda (i) (concat "-X" i)) ext)
                          )))
    (inferior-haskell-start-process command)
;    (loop for i in command do (message i))
    )
  )

(provide 'inf-cabal-dev)



