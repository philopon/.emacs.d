(require 'myfunctions)
(install-if-not-exists 'auto-complete)

(require 'auto-complete-config)

(add-to-list 'ac-dictionary-directories
             (concat (package-directory 'auto-complete) "dict")
             )
(ac-config-default)

;; メニューマップ使用
(setq ac-use-menu-map t)

;; n文字で補完スタート
(setq ac-auto-start 1)

;; 大文字/小文字を補完対象に大文字が含まれる場合のみ区別する
(setq ac-ignore-case 'smart)

;; すべてのbufferで読み込むソース
(defun ac-common-setup ()
  (add-to-list 'ac-sources 'ac-source-filename)
;   (add-to-list 'ac-sources 'ac-source-yasnippet)
  )

;; キーバインド
(define-key ac-completing-map "\C-g" 'ac-stop)


