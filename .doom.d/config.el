;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-solarized-light)
(setq doom-font (font-spec :family "Sarasa Mono SC" :size 24))

(package! evil-terminal-cursor-changer)
(use-package! evil-terminal-cursor-changer
  :init
   (setq etcc-use-blink nil)
   (evil-terminal-cursor-changer-activate))

(map! :leader :prefix "f" :n "s" 'save-buffer)

(when window-system (set-frame-size (selected-frame) 160 48))
(setq confirm-kill-emacs nil)

(setq doom-modeline-height 25
      doom-modeline-icon nil)


(setq font-lock-maximum-decoration '((c-mode . t) (c++-mode . 2) (t . 2)))

(after! company
  (setq company-minimum-prefix-length 2
        company-show-numbers t)
  ;; Disable company-yasnippet, it is laggy af
  (set-company-backend! 'prog-mode nil))

(after! flycheck
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  (global-flycheck-mode -1))

(after! flymake-proc
  (setq-default flymake-diagnostic-functions nil))

(after! ccls
  (setq ccls-sem-highlight-method nil)
  (setq
   ccls-initialization-options
   `(:diagnostics
     (:onChange 2000 :spellChecking :json-false)
     :index
     (:initialNoLinkage t :name (:suppressUnwrittenScope t))
     :completion
     (:caseSensitivity 1)))
  (add-to-list 'projectile-globally-ignored-directories ".ccls-cache")
  (evil-set-initial-state 'ccls-tree-mode 'emacs))

(after! lsp-ui
  (setq lsp-ui-sideline-show-hover nil
        lsp-ui-sideline-show-symbol nil
        lsp-ui-doc-enable nil
        lsp-ui-peek-force-fontify nil
        lsp-ui-peek-expand-function (lambda (xs) (mapcar #'car xs)))
  (custom-set-faces
   '(ccls-sem-global-variable-face ((t (:underline t :weight extra-bold))))
   ;; '(lsp-face-highlight-read ((t (:background "sea green"))))
   ;; '(lsp-face-highlight-write ((t (:background "brown4"))))
   )
  (map! :after lsp-ui-peek
        :map lsp-ui-peek-mode-map
        "h" #'lsp-ui-peek--select-prev-file
        "j" #'lsp-ui-peek--select-next
        "k" #'lsp-ui-peek--select-prev
        "l" #'lsp-ui-peek--select-next-file
        )
  (defhydra hydra/ref (evil-normal-state-map "'")
    "reference"
    ("p" (-let [(i . n) (lsp-ui-find-prev-reference)]
           (if (> n 0) (message "%d/%d" i n))) "prev")
    ("n" (-let [(i . n) (lsp-ui-find-next-reference)]
           (if (> n 0) (message "%d/%d" i n))) "next")
    ("R" (-let [(i . n) (lsp-ui-find-prev-reference '(:role 8))]
           (if (> n 0) (message "read %d/%d" i n))) "prev read" :bind nil)
    ("r" (-let [(i . n) (lsp-ui-find-next-reference '(:role 8))]
           (if (> n 0) (message "read %d/%d" i n))) "next read" :bind nil)
    ("W" (-let [(i . n) (lsp-ui-find-prev-reference '(:role 16))]
           (if (> n 0) (message "write %d/%d" i n))) "prev write" :bind nil)
    ("w" (-let [(i . n) (lsp-ui-find-next-reference '(:role 16))]
           (if (> n 0) (message "write %d/%d" i n))) "next write" :bind nil)
    ))
