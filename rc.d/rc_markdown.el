(use-package 'markdown-mode)

(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(when (require 'rc_zencoding nil t)
  (add-hook 'markdown-mode-hook 'zencoding-mode))

(provide 'rc_markdown)
