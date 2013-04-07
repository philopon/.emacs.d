(use-package 'projectile)

(setq projectile-use-native-indexing t)
(setq projectile-enable-caching t)
(setq projectile-cache-file "~/.emacs.tmp.d/projectile.cache")
(setq projectile-known-projects-file "~/.emacs.tmp.d/projectile-bookmarks.eld")

(defun projectile-cache-all-file ()
  (interactive)
  (let* ((root (projectile-project-root))
         (projectile-enable-caching nil)
         (all-files (projectile-project-files root))
         (projectile-enable-caching t))
    (projectile-cache-project root all-files)))

(projectile-global-mode)

(use-package 'helm-projectile)
(require 'rc_helm)
(global-set-key (kbd "C-c h") 'helm-projectile)
(global-set-key (kbd (concat projectile-keymap-prefix "c")) 'projectile-cache-all-file)


(provide 'rc_projectile)
