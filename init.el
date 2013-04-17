;(setq max-specpdl-size 3000)
;(setq max-lisp-eval-depth 2000)

(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(unless (file-exists-p "~/.emacs.d/elpa/archives")
  (package-refresh-contents))

;; テンポラリディレクトリの作成
(unless (file-exists-p "~/.emacs.tmp.d")
  (make-directory "~/.emacs.tmp.d"))

;; exec-pathの退避
(setq default-exec-path exec-path)

(defun use-package (name)
  (when (not (package-installed-p name))
    (package-install name)))

;; exec-path/PATH登録
(when (file-exists-p "~/.launchd.conf")
  (with-temp-buffer
    (insert-file-contents "~/.launchd.conf")
    (let ((lines (split-string (buffer-substring-no-properties (point-min) (point-max)) "\n")))
      (while lines
        (let* ((line (car lines))
               (split (split-string line " +"))
               (cmd   (car split))
               (key   (car (cdr split)))
               (value (car (cdr (cdr split))))
               )
          (when (and (string= cmd "setenv") key value)
            (setq exec-path (append default-exec-path (print (split-string value ":"))))
            (setenv key value))
          (setq lines (cdr lines)))))))


;; global設定
(load "~/.emacs.d/global")

;; パッケージごとの設定
(add-to-list 'load-path "~/.emacs.d/rc.d")
(let ((files (directory-files "~/.emacs.d/rc.d/")))
  (while files
    (let ((file (car files)))
      (when (string-match-p "\.el$" file)
        (require (intern (substring file 0 (- (length file) 3)))))
      (setq files (cdr files))
      )))



