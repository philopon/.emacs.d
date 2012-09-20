(setq history-length t)

(setq undo-limit 800000)
(setq undo-strong-limit 1200000)

(require 'myfunctions)
(install-if-not-exists 'undo-tree)

(setq undo-tree-auto-save-history t)
(setq undo-tree-visualizer-timestamps t)

(unless (file-exists-p "~/.emacs.d/undotree")
  (make-directory "~/.emacs.d/undotree")
)

(setq undo-tree-history-directory-alist
      (cons (cons "." (expand-file-name "~/.emacs.d/undotree"))
            nil))


(global-undo-tree-mode)



