;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; Org mode

(package! ox-reveal)
(package! org-reverse-datetree)
(package! org-sticky-header)
(package! org-present
  :recipe (:host github :repo "rlister/org-present"))

;; Completion

;; Display help next to completion
(package! company-quickhelp)

;; Navigation

;; Open links with one letter
(package! ace-link)
;; Go to last change
(package! goto-last-change)

;; Miscellanoues

;; Visual bookmarks
(package! bm)
;; Show flycheck erros as tooltip
(package! flycheck-pos-tip)
;; Google thing-at-point
(package! google-this)
;; Live previews
(package! impatient-mode)
;; Pandoc integration
(package! pandoc-mode)
;; Common string transformations
(package! string-inflection)
