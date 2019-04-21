;;; flycheck-objc-clang-test.el --- Flycheck Objective-C Clang: Test cases

;; Copyright (c) 2016-2019 GyazSquare Inc.

;; Author: Goichi Hirakawa <gooichi@gyazsquare.com>
;; URL: https://github.com/GyazSquare/flycheck-objc-clang

;; This file is not part of GNU Emacs.

;; MIT License

;; Permission is hereby granted, free of charge, to any person obtaining
;; a copy of this software and associated documentation files (the
;; "Software"), to deal in the Software without restriction, including
;; without limitation the rights to use, copy, modify, merge, publish,
;; distribute, sublicense, and/or sell copies of the Software, and to
;; permit persons to whom the Software is furnished to do so, subject to
;; the following conditions:

;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
;; BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
;; ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
;; CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;;; Commentary:

;; Test cases Flycheck Objective-C Clang.

;;; Code:

(require 'flycheck-ert)
(require 'flycheck-objc-clang)

(message "Running tests on Emacs %s" emacs-version)

(defconst flycheck-objc-clang-test-directory
  (let ((filename (if load-in-progress load-file-name (buffer-file-name))))
    (expand-file-name "test/" (locate-dominating-file filename "Cask")))
  "Test suite directory, for resource loading.")

(flycheck-ert-def-checker-test objc-clang objc error
  (let ((flycheck-checkers '(objc-clang))
        (flycheck-swift3-xcrun-sdk "macosx")
        (flycheck-objc-clang-warnings nil))
    (flycheck-ert-should-syntax-check
     "missing-closing-rbrace.m" 'objc-mode
     '(3 16 error "'@end' appears where closing brace '}' is expected"
         :checker objc-clang))))

(flycheck-ert-def-checker-test objc-clang objc error-included-file
  (let ((flycheck-checkers '(objc-clang))
        (flycheck-swift3-xcrun-sdk "macosx")
        (flycheck-objc-clang-warnings nil))
    (flycheck-ert-should-syntax-check
     "error-include.m" 'objc-mode
     '(2 nil error "In include ./error-no-message.h" :checker objc-clang)
     `(2 2 error "no message" :checker objc-clang
         :filename ,(expand-file-name "error-no-message.h"
                                      flycheck-objc-clang-test-directory)))))

(flycheck-ert-def-checker-test objc-clang objc error-no-message
(let ((flycheck-checkers '(objc-clang))
      (flycheck-swift3-xcrun-sdk "macosx")
      (flycheck-objc-clang-warnings nil))
    (flycheck-ert-should-syntax-check
     "error-no-message.h" 'objc-mode
     '(2 2 error "no message" :checker objc-clang))))

(flycheck-ert-def-checker-test objc-clang objc error-info
  (let ((flycheck-checkers '(objc-clang))
        (flycheck-swift3-xcrun-sdk "macosx")
        (flycheck-objc-clang-warnings nil))
    (flycheck-ert-should-syntax-check
     "missing-end.m" 'objc-mode
     '(3 1 info "class started here" :checker objc-clang)
     '(6 3 error "expected an Objective-C directive after '@'"
         :checker objc-clang)
     '(7 36 error "missing '@end'" :checker objc-clang))))

(flycheck-ert-def-checker-test objc-clang objc warning
  (let ((flycheck-checkers '(objc-clang))
        (flycheck-swift3-xcrun-sdk "macosx")
        (flycheck-objc-clang-warnings nil))
    (flycheck-ert-should-syntax-check
     "expressions.m" 'objc-mode
     '(4 3 warning "expression result unused" :checker objc-clang))))

(flycheck-ert-def-checker-test objc-clang objc warning-included-file
  (let ((flycheck-checkers '(objc-clang))
        (flycheck-swift3-xcrun-sdk "macosx")
        (flycheck-objc-clang-warnings nil))
    (flycheck-ert-should-syntax-check
     "warning-include.m" 'objc-mode
     '(2 nil warning "In include ./warning-no-message.h" :checker objc-clang))))

(flycheck-ert-def-checker-test objc-clang objc warning-no-message
  (let ((flycheck-checkers '(objc-clang))
        (flycheck-swift3-xcrun-sdk "macosx")
        (flycheck-objc-clang-warnings nil))
    (flycheck-ert-should-syntax-check
     "warning-no-message.h" 'objc-mode
     '(2 2 warning "no message" :checker objc-clang))))

(flycheck-ert-def-checker-test objc-clang objc warning-info
  (let ((flycheck-checkers '(objc-clang))
        (flycheck-swift3-xcrun-sdk "macosx")
        (flycheck-objc-clang-warnings nil))
    (flycheck-ert-should-syntax-check
     "unqualified-to-qualified-class-warn.m" 'objc-mode
     '(21 66 info "passing argument to parameter 'instance' here"
          :checker objc-clang)
     '(27 47 warning "incompatible pointer types passing 'AClass *' to parameter of type 'AClass<Fooable> *'"
          :checker objc-clang))))

(flycheck-ert-def-checker-test objc-clang objc mrc-weak
  (let ((flycheck-checkers '(objc-clang))
        (flycheck-swift3-xcrun-sdk "macosx")
        (flycheck-objc-clang-weak t)
        (flycheck-objc-clang-warnings nil))
    (flycheck-ert-should-syntax-check
     "mrc-weak.m" 'objc-mode
     '(5 21 info "property declared here" :checker objc-clang)
     '(7 21 info "property declared here" :checker objc-clang)
     '(10 34 info "property declared here" :checker objc-clang)
     '(14 23 info "property declared here" :checker objc-clang)
     '(20 6 error "existing instance variable '_wa' for __weak property 'wa' must be __weak"
          :checker objc-clang)
     '(22 26 error "existing instance variable '_wc' for __weak property 'wc' must be __weak"
          :checker objc-clang)
     '(24 13 error "existing instance variable '_ub' for property 'ub' with unsafe_unretained attribute must be __unsafe_unretained"
          :checker objc-clang)
     '(27 13 error "existing instance variable '_sb' for strong property 'sb' may not be __weak"
          :checker objc-clang)
     '(30 13 info "property synthesized here" :checker objc-clang)
     '(32 13 info "property synthesized here" :checker objc-clang)
     '(35 13 info "property synthesized here" :checker objc-clang)
     '(39 13 info "property synthesized here" :checker objc-clang)
     '(45 3 error "cannot jump from this goto statement to its label"
          :checker objc-clang)
     '(46 13 info "jump bypasses initialization of __weak variable"
          :checker objc-clang)
     '(53 7 error "initializing 'id *' with an expression of type '__weak id *' changes retain/release properties of pointer"
          :checker objc-clang)
     '(54 14 error "initializing '__weak id *' with an expression of type 'id *' changes retain/release properties of pointer"
          :checker objc-clang)
     '(65 27 error "initializing 'id *' with an expression of type '__weak id *' changes retain/release properties of pointer"
          :checker objc-clang))))

(flycheck-ert-initialize flycheck-objc-clang-test-directory)

(provide 'flycheck-objc-clang-test)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:

;;; flycheck-objc-clang-test.el ends here
