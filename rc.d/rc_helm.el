
(use-package 'helm)
(add-hook 'helm-before-initialize-hook
          (lambda () 
            (add-to-list 'helm-boring-buffer-regexp-list "*Backtrace*")
            (add-to-list 'helm-boring-buffer-regexp-list "*Messages*")
            (add-to-list 'helm-boring-buffer-regexp-list "*Completions*")
            (add-to-list 'helm-boring-buffer-regexp-list "*Debug Helm Log*")))

(global-set-key (kbd "M-x")     'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
(global-set-key (kbd "M-y")     'helm-show-kill-ring)
(global-set-key (kbd "C-x C-r") 'helm-recentf)
(global-set-key [(super q)]     'helm-resume)

(use-package 'helm-ls-git)

(provide 'rc_helm)
