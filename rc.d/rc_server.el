(require 'server)
(unless (server-running-p) (server-start))

;; http://d.hatena.ne.jp/buzztaiki/20071113/1194932700
(defun server-edit-cancel (&optional arg)
  (interactive "P")
  (when (y-or-n-p (concat "Cancel file " buffer-file-name "? "))
    (set-buffer-modified-p nil)
    (server-edit arg)))

(add-hook 'server-switch-hook
          (lambda ()
            (when (current-local-map)
              (use-local-map (copy-keymap (current-local-map))))
            (when server-buffer-clients
              (local-set-key (kbd "C-x k") 'server-edit)
              (local-set-key (kbd "C-c C-c") 'server-edit)
              (local-set-key (kbd "C-c C-k") 'server-edit-cancel)
              )))


(provide 'rc_server)
