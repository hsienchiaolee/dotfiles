;;; setup-interface.el --- Setup interface -*- lexical-binding: t; -*-
;;; Commentary:

;;; This package sets up the emacs interface and set macOS specific
;;; configurations.

;; Font
(set-face-attribute 'default nil
                    :family "Menlo"
                    :height 160)
(set-face-attribute 'fixed-pitch nil
                    :family 'unspecified
                    :inherit 'default)

;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tabbar-mode) (tabbar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; macOS specific settings
(setq ns-use-srgb-colorspace nil) ;; disables the use of the sRGB colorspace to prevent color mismatches
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))

;; vertical window split
(setq split-width-threshold 190)
(setq split-height-threshold nil)

;; Line wrap indicator
(setq-default visual-line-fringe-indicators '(left-curly-arrow nil))

;; Fill column
(setq fill-column 80)

(show-paren-mode 1)

(provide 'setup-interface)
