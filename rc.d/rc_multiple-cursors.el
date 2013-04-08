(require 'rc_smartrep)

(use-package 'multiple-cursors)

(global-unset-key (kbd "C-t"))

(smartrep-define-key global-map (kbd "C-t")
  '(("C-t" . 'mc/edit-lines)
    ("C-a" . 'mc/edit-beginnings-of-lines)
    ("C-e" . 'mc/edit-ends-of-lines)

    ("C-p" . 'mc/mark-previous-word-like-this)
    ("C-n" . 'mc/mark-next-word-like-this)
    ("*"   . 'mc/mark-all-like-this)))


(provide 'rc_multiple-cursors)
