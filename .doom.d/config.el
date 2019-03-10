;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Sarasa Mono SC" :size 24))
(def-package! company)
(setq company-idle-delay 0)

(def-package! evil-terminal-cursor-changer
  :init
   (setq etcc-use-blink nil)
   (evil-terminal-cursor-changer-activate))

(map! :leader :prefix "f" :n "s" 'save-buffer)

(when window-system (set-frame-size (selected-frame) 160 48))
(load-theme 'sanityinc-tomorrow-night t)
(setq confirm-kill-emacs nil)
(setq doom-modeline-height 30)
