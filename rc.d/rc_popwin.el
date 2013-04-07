(use-package 'popwin)
(require 'popwin)
(require 'dired-x)

(setq display-buffer-function 'popwin:display-buffer)
(push '(".*helm.*" :regexp t :height 20) popwin:special-display-config)
(push '(dired-mode :position left :width 100) popwin:special-display-config)
(global-set-key (kbd "C-x d") 'dired-jump-other-window)

(provide 'rc_popwin)
