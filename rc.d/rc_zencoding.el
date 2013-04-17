(use-package 'zencoding-mode)

(add-hook 'html-mode-hook 'zencoding-mode)
(add-hook 'sgml-mode-hook 'zencoding-mode)

(require 'rc_markdown)
(add-hook 'markdown-mode-hook 'zencoding-mode)

(provide 'rc_zencoding)
