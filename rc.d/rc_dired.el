;; http://qiita.com/items/13585a5711d62e9800ef
(defun dired-my-append-buffer-name-hint ()
  "Append a auxiliary string to a name of dired buffer."
  (when (eq major-mode 'dired-mode)
      (rename-buffer (concat "[Dired] " (buffer-name)) t)))

(add-hook 'dired-mode-hook 'dired-my-append-buffer-name-hint)

(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

(require 'dired-x)

(when (require 'rc_popwin nil t)
  (push '(dired-mode :position left :width 100) popwin:special-display-config)
  (global-set-key (kbd "C-x d") 'dired-jump-other-window))

(provide 'rc_dired)
