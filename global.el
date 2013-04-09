;; フォント設定
(set-face-attribute 'default nil
                    :family "Ricty Discord"
                    :height 135)
(set-fontset-font
 nil 'japanese-jisx0208
 (font-spec :family "Ricty Discord"))


;; 対応するカッコをハイライト
(show-paren-mode t)

;; カーソル点滅を無効に
(blink-cursor-mode 0)

;; スクロールバー/ツールバー非表示
(when (symbol-value 'window-system) 
  (set-scroll-bar-mode nil)
  (tool-bar-mode -1))

;;行、列番号表示
(column-number-mode t)

;; http://d.hatena.ne.jp/daimatz/20120215/1329248780
(setq linum-delay t)
(defadvice linum-schedule (around my-linum-schedule () activate)
  (run-with-idle-timer 0.2 nil #'linum-update-current))

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

;; scratchの初期メッセージ消去
(setq initial-scratch-message "")

;; Emacsからの質問を y/n で回答する
(fset 'yes-or-no-p 'y-or-n-p)

;; インデントはspace
(setq-default indent-tabs-mode nil)

;; 矩形選択
(cua-mode t)
(setq cua-enable-cua-keys nil)

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

;; 保存時に自動で実行属性付加
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; バックアップファイルの場所
(unless (file-exists-p "~/.emacs.tmp.d/backup")
  (make-directory "~/.emacs.tmp.d/backup"))

(setq backup-directory-alist
      (cons (cons "\\.*$" (expand-file-name "~/.emacs.tmp.d/backup"))
            backup-directory-alist))


(setq auto-save-list-file-prefix "~/.emacs.tmp.d/auto-save-list/.saves-")


;;改行キーでオートインデントさせる．
(global-set-key "\C-m" 'newline-and-indent)
(global-set-key "\C-j" 'newline)

;;バックスペース
(load "term/bobcat")
(when (fboundp 'terminal-init-bobcat)
  (terminal-init-bobcat))

;; 数引数でgoto-lineするC-v/M-v
(defun num-prefixed-C-v (n)
  (interactive "P")
  (if n (goto-line n) (scroll-up)))

(defun num-prefixed-M-v (n)
  (interactive "P")
  (if n (goto-line n) (scroll-down)))

(global-set-key (kbd "C-v") 'num-prefixed-C-v)
(global-set-key (kbd "M-v") 'num-prefixed-M-v)

;; emacs server
(require 'server)
(unless (server-running-p) (server-start))

;; サスペンド終了関係の無効化
(when (symbol-value 'window-system) 
  (global-set-key (kbd "C-z") nil)
  (global-unset-key (kbd "C-x C-c"))
  (global-unset-key [(super q)]))
(defalias 'exit-emacs 'save-buffers-kill-emacs)



