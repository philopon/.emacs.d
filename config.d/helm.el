(require 'myfunctions)
(install-if-not-exists 'helm)

(setq helm-command-prefix-key (kbd "C-x C-x"))
(require 'helm-config)
(require 'helm-misc)

(helm-mode t)

(defun helm-buffer-menu ()
  (interactive)
  (helm :buffer "*helm buffer menu*"
        :sources '(helm-c-source-buffers-list
                   helm-c-source-buffer-not-found
                   helm-c-source-files-in-current-dir
                   helm-c-source-recentf
                   helm-c-source-mac-spotlight
                   )
        :resume
        ))

(defun helm-do-grep-last-targets ()
  (interactive)
  (helm-do-grep-1 helm-grep-last-targets)
  )


(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x C-b") 'helm-buffer-menu)

(global-set-key (kbd "C-x C-g") 'helm-do-grep)
(global-set-key (kbd "C-x M-g") 'helm-do-grep-last-targets)

(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x <C-SPC>") 'helm-all-mark-rings)
