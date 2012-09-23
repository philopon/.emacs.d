(require 'cl)

(defun package-fetched-p ()
  (loop with result = t
        for package in package-archives
        for file = (concat "~/.emacs.d/elpa/archives/" (car package) "/archive-contents")
        do (setq result (and result (file-exists-p file)))
        finally return result
        ))

(defun package-directory (package)
  (let ((ver      (package-desc-vers (cdr (assq package package-alist)))))
    (concat package-user-dir "/"
            (symbol-name package) "-"
            (number-to-string (car ver)) "."
            (number-to-string (car (cdr ver))) "/"
            )
    ))

(defun install-if-not-exists (package)
  (unless (package-installed-p package)
    (package-install package)))

;; 数引数が渡されたら goto-line する scroll
(defun scroll-up-or-goto-line (n)
  (interactive "p")
  (if (> n 1)
      (goto-line n)
      (scroll-up)
    )
 )

(defun scroll-down-or-goto-line (n)
  (interactive "p")
  (if (> n 1)
      (goto-line n)
      (scroll-down)
    )
 )

(defun get-path-from-environment-plist (&optional nokill)
  (let ((buf (find-file-noselect "~/.MacOSX/environment.plist")) begin result)
    (with-current-buffer buf
      (goto-char (point-min))
      (re-search-forward "<key>PATH</key>")
      (re-search-forward "<string>")
      (setq begin (point))
      (re-search-forward "</string>")
      (setq result (split-string (buffer-substring-no-properties begin (- (point) 9)) ":"))
      )
    (unless nokill (kill-buffer buf))
    result
    )
  )

(defun exec-path-to-env (list)
  (apply 'concat (loop for path in list
                       collect (concat path ":")
                       )))

(provide 'myfunctions)


