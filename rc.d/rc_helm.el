
(use-package 'helm)
(add-hook 'helm-before-initialize-hook
          (lambda () 
            (add-to-list 'helm-boring-buffer-regexp-list "*Backtrace*")
            (add-to-list 'helm-boring-buffer-regexp-list "*Messages*")
            (add-to-list 'helm-boring-buffer-regexp-list "*Completions*")
            (add-to-list 'helm-boring-buffer-regexp-list "*Debug Helm Log*")))

(setq helm-for-files-preferred-list
  '(helm-source-buffers-list
    helm-source-buffer-not-found
;    helm-source-recentf
    helm-source-bookmarks
    helm-source-file-cache
;    helm-source-files-in-current-dir
;    helm-source-locate
    helm-source-mac-spotlight))


(global-set-key (kbd "M-x")     'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-b") 'helm-for-files)
(global-set-key (kbd "M-y")     'helm-show-kill-ring)
(global-set-key (kbd "C-x C-r") 'helm-recentf)
(global-set-key [(super q)]     'helm-resume)

(use-package 'helm-ls-git)

(when (require 'rc_popwin nil t)
  (push '("^\\*helm.*\\*$" :regexp t)      popwin:special-display-config))

(provide 'rc_helm)
