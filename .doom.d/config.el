;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Sarasa Mono SC" :size 24))

(def-package! evil-terminal-cursor-changer
  :init
   (setq etcc-use-blink nil)
   (evil-terminal-cursor-changer-activate))

(map! :leader :prefix "f" :n "s" 'save-buffer)

(when window-system (set-frame-size (selected-frame) 160 48))
;; (load-theme 'doom-solarized-light t)
(load-theme 'doom-tomorrow-night t)
(setq confirm-kill-emacs nil)

(setq doom-modeline-height 25
      doom-modeline-icon nil)

(setq lsp-ui-sideline-show-hover nil
      lsp-ui-sideline-show-symbol nil
      lsp-ui-doc-enable nil)

(after! cc-mode
  (set-company-backend! 'c++-mode
    '(company-lsp)))
