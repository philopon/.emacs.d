(require 'rc_pos-tip)

(use-package 'auto-complete)
(require 'auto-complete-config)

(define-key ac-completing-map "\M-/" 'ac-stop)
(setq ac-comphist-file "~/.emacs.tmp.d/ac-comphist.dat")
(setq ac-use-menu-map t)
(setq ac-auto-show-menu 0.5)
(setq ac-use-fuzzy t)
(setq ac-quick-help-delay 1.0)
(ac-config-default)

(when (require 'rc_helm nil t)
  (use-package 'ac-helm)
  (require 'ac-helm)
  (define-key ac-complete-mode-map (kbd "C-;") 'ac-complete-with-helm))

(provide 'rc_auto-complete)
