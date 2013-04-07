(use-package 'undo-tree)

(global-undo-tree-mode)

(setq undo-tree-auto-save-history t)

(unless (file-exists-p "~/.emacs.tmp.d/undo-tree")
  (make-directory "~/.emacs.tmp.d/undo-tree"))

(setq undo-tree-history-directory-alist
      '((".*" . "~/.emacs.tmp.d/undo-tree")))

(global-set-key (kbd "C-/") 'undo-tree-undo)
(global-set-key (kbd "C-S-/") 'undo-tree-redo)

(provide 'rc_undo-tree)

