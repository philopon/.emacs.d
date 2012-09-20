;;;; UI ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; フォント設定
(when (eq window-system 'ns)
  (set-fontset-font (frame-parameter nil 'font)
                    'japanese-jisx0208
                    '("Ricty Discord" . "iso10646-1"))
  )

(when (eq system-type 'windows-nt)
  (set-face-attribute 'default nil
                      :family "Ricty Discord"
                      :height 130)
)

;; 対応するカッコをハイライト
(show-paren-mode t)

;; カーソル点滅を無効に
(blink-cursor-mode 0)


;; スクロールバー非表示
(when (symbol-value 'window-system) (set-scroll-bar-mode nil))

;;ツールバー非表示
(when (symbol-value 'window-system) (tool-bar-mode -1))

;;行、列番号表示
(column-number-mode t)

;; 左に行番号
(global-linum-mode t)
(setq linum-format "%4d")

;;起動画面を表示しない
(setq inhibit-startup-message t)

;; i-search終了後もハイライト
(make-face 'my-highlight-face)
(set-face-foreground 'my-highlight-face "black")
(set-face-background 'my-highlight-face "aquamarine")
(setq lazy-highlight-face 'my-highlight-face)
(setq lazy-highlight-cleanup nil)


;;バッファ名をユニークに
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; タブ文字、スペース強調
(defface my-face-b-1 '((t (:background "medium aquamarine"))) nil)
(defface my-face-b-2 '((t (:background "gray26"))) nil)
(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)
(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(
     ("　" 0 my-face-b-1 append)
     ("\t" 0 my-face-b-2 append)
     ("[ ]+$" 0 my-face-u-1 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)

(ad-activate 'font-lock-mode)
(add-hook 'find-file-hooks '(lambda ()
                              (if font-lock-mode
                                  nil
                                (font-lock-mode t)))
          t)

;; scratchの初期メッセージ消去
(setq initial-scratch-message "")

;;;; Input ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Emacsからの質問を y/n で回答する
(fset 'yes-or-no-p 'y-or-n-p)

;; インデントはspace
(setq-default indent-tabs-mode nil)

;; 矩形選択
(cua-mode t)
(setq cua-enable-cua-keys nil)

;;;; Open ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 言語設定
(set-language-environment "Japanese")
(set-default-coding-systems 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)

;; D&D時新規バッファに開く
(setq ns-pop-up-frames nil)
(define-key global-map [ns-drag-file] 'ns-find-file)

;; recentf上限
(require 'recentf)
(setq recentf-max-menu-items 2000)
(setq recentf-max-saved-items 2000)
(setq recentf-exclude '(".recentf"))

;;;; Close ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 保存時に自動で実行属性付加
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)


;; バックアップファイルの場所
(unless (file-exists-p "~/.emacs.d/backup")
  (make-directory "~/.emacs.d/backup")
)
(setq backup-directory-alist
      (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/backup"))
            backup-directory-alist))


;;;; key assign ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;改行キーでオートインデントさせる．
(global-set-key "\C-m" 'newline-and-indent)
(global-set-key "\C-j" 'newline)

;;Command - option 入れ替え
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

;;バックスペース
(load "term/bobcat")
(when (fboundp 'terminal-init-bobcat)
  (terminal-init-bobcat))


(require 'myfunctions)
(global-set-key "\C-v" 'scroll-up-or-goto-line)
(global-set-key "\M-v" 'scroll-down-or-goto-line)
