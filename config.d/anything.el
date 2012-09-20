(require 'myfunctions)

(install-if-not-exists 'anything)
(install-if-not-exists 'anything-complete)
(install-if-not-exists 'anything-config)
(install-if-not-exists 'anything-extension)
(install-if-not-exists 'anything-obsolete)

(require 'anything-config)

(setq anything-sources
      '(anything-c-source-buffers+
        anything-c-source-recentf
        anything-c-source-mac-spotlight
        )
)

;; http://qiita.com/items/2940
(defun anything-c-sources-git-project-for (pwd)
  (loop for elt in
        '(("Modified files (%s)" . "--modified")
          ("Untracked files (%s)" . "--others --exclude-standard")
          ("All controlled files in this project (%s)" . ""))
        collect
        `((name . ,(format (car elt) pwd))
          (init . (lambda ()
                    (unless (and ,(string= (cdr elt) "") ;update candidate buffer every time except for that of all project files
                                 (anything-candidate-buffer))
                      (with-current-buffer
                          (anything-candidate-buffer 'global)
                        (insert
                         (shell-command-to-string
                          ,(format "git ls-files $(git rev-parse --show-cdup) %s"
                                   (cdr elt))))))))
          (candidates-in-buffer)
          (type . file)))
  )

(defun anything-git-project ()
  (interactive)
  (let* ((pwd (shell-command-to-string "echo -n `pwd`"))
         (sources (anything-c-sources-git-project-for pwd)))
    (anything-other-buffer sources
                           (format "*Anything git project in %s*" pwd)))
  )

;; キーバインド
(global-set-key (kbd "M-x") 'anything-M-x)
(global-set-key (kbd "M-y") 'anything-show-kill-ring)
(global-set-key (kbd "C-x C-b") 'anything)
(global-set-key (kbd "C-x g") 'anything-google-suggest)
(global-set-key (kbd "C-x C-g") 'anything-git-project)

(global-set-key (kbd "C-x c") 'anything-lisp-completion-at-point)
(global-set-key (kbd "C-x a i") 'anything-imenu)
