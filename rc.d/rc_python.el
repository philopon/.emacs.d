(use-package 'jedi)
(use-package 'python-mode)

(setq python-indent-offset 4)

(defun jedi-python-mode-hook ()
  (when (and (= (call-process (executable-find "python") nil nil nil "-c" "import epc, jedi") 0)
             (require 'rc_auto-complete nil t))
    (auto-complete-mode t)
    (jedi:ac-setup)
    (jedi-mode t)
    )
  )

(add-hook 'python-mode-hook 'jedi-python-mode-hook)


(provide 'rc_python)
