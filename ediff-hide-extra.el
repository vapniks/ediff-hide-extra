;;; ediff-hide-extra.el --- Hide different lines in ediff based on major mode

;; Filename: ediff-hide-extra.el
;; Description: Hide different lines in ediff based on major mode
;; Author: Joe Bloggs <vapniks@yahoo.com>
;; Maintainer: Joe Bloggs <vapniks@yahoo.com>
;; Copyleft (Ↄ) 2015, Joe Bloggs, all rites reversed.
;; Created: 2015-09-02 14:09:15
;; Version: 0.1
;; Last-Updated: 2015-09-02 14:09:15
;;           By: Joe Bloggs
;; URL: https://github.com/vapniks/ediff-hide-extra
;; Keywords: convenience
;; Compatibility: GNU Emacs 24.5.1
;; Package-Requires: 
;;
;; Features that might be required by this library:
;;
;; ediff
;;

;; This file is NOT part of GNU Emacs

;;; License
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.
;; If not, see <http://www.gnu.org/licenses/>.

;;; Commentary
;;
;; Bitcoin donations gratefully accepted: 12k9zUo9Dgqk8Rary2cuzyvAQWD5EAuZ4q
;;
;; This package sets some default regexps for hiding lines based on `major-mode'
;; of ediff buffers when #h is pressed.
;;

;;; Customizable Options:
;;
;; Below are customizable option list:
;;
;;  `ediff-hide-regexp-defaults-alist' : regexps matching lines to hide for each major-mode
;;
;; 
;;;;


;;; Installation:
;;
;; Put ediff-hide-extra.el in a directory in your load-path, e.g. ~/.emacs.d/
;; You can add a directory to your load-path with the following line in ~/.emacs
;; (add-to-list 'load-path (expand-file-name "~/elisp"))
;; where ~/elisp is the directory you want to add 
;; (you don't need to do this for ~/.emacs.d - it's added by default).
;;
;; Add the following to your ~/.emacs startup file.
;;
;; (require 'ediff-hide-extra)
;;
;; Add `ediff-hide-regexp-defaults-alist' to the list of functions in `ediff-prepare-buffer-hook' :
;;
;; M-x customize-variable RET ediff-prepare-buffer-hook RET
;;

;;; Require
(require 'ediff)

;;; Code

(defcustom ediff-hide-regexp-defaults-alist
  '((c-mode "^\\([      ]*/?\\*\\|[     ]*//\\)")
    (c++-mode "^\\([    ]*/?\\*\\|[     ]*//\\)")
    (cuda-mode "^\\([   ]*/?\\*\\|[     ]*//\\)")
    (emacs-lisp-mode "^ *;+")
    (ess-mode "^ *#+"))
  "Alist of (MAJOR-MODE . REGEXP) pairs. Where REGEXP is the default regular expression to use
          for the `ediff-hide-regexp-matches' function in buffers with major mode equal to MAJOR-MODE"
  :type '(alist :key-type symbol :value-type regexp)
  :group 'ediff-diff)

;;;###autoload
(defun ediff-hide-regexp-set-defaults ()
  "Function to be called by `ediff-prepare-buffer-hook' to set the default regexp's for
selective browsing when #h is pressed."
  (let* ((control-buffer (if (and (boundp 'control-buffer)
				  (bufferp (symbol-value 'control-buffer)))
			     (symbol-value 'control-buffer)
			   ediff-control-buffer))
	 (bufs (with-current-buffer control-buffer
		 (list ediff-buffer-A
		       ediff-buffer-B
		       ediff-buffer-C)))
	 (val (or (cadr (assoc major-mode ediff-hide-regexp-defaults-alist)) "")))
    (cond ((eq (current-buffer) (first bufs))
	   (with-current-buffer control-buffer
	     (setq ediff-regexp-hide-A val)))
	  ((eq (current-buffer) (second bufs))
	   (with-current-buffer control-buffer
	     (setq ediff-regexp-hide-B val)))
	  ((eq (current-buffer) (third bufs))
	   (with-current-buffer control-buffer
	     (setq ediff-regexp-hide-C val))))))

(add-hook 'ediff-prepare-buffer-hook 'ediff-hide-regexp-set-defaults)
(add-hook 'ediff-startup-hook 'ediff-hide-regexp-set-defaults)

(provide 'ediff-hide-extra)

;; (magit-push)
;; (yaoddmuse-post "EmacsWiki" "ediff-hide-extra.el" (buffer-name) (buffer-string) "update")

;;; ediff-hide-extra.el ends here

