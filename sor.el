;;; sor.el --- an `or' which always evaluates all conditions

;; Copyright (C) 2013  Jonas Bernoulli

;; Author: Jonas Bernoulli <jonas@bernoul.li>
;; Created: 20130424
;; Version: 0.1.0
;; Status: just for fun
;; Homepage: https://github.com/tarsius/sor

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This function defines the form `sor'.  Unlike `or' which evaluates
;; the conditions until one yields non-nil and then returns that value
;; `sor' always evaluates all conditions for side effects and only
;; then returns the first non-nil value. `sor' stands for "`or' with
;; more [s]ide effects".

;; I have written `sor' because I stumbled upon a blog post claiming
;; that most programmers are not able to solve the FizzBuzz problem.
;; I was able to solve it but was not satisfied with my first
;; solution.  Banging on it a bit I came up with this:

;; (cl-loop for i from 1 to 100 do
;;          (or (sor (and (= (mod i 3) 0) (princ "Fizz"))
;;                   (and (= (mod i 5) 0) (princ "Buzz")))
;;              (princ i))
;;          (princ "\n"))

;; Unfortunately I could not find a form that does what is required of
;; `sor' - so I wrote it myself.  If there actually is an existing
;; name for this form please let me know.

;; Also see http://c2.com/cgi/wiki?FizzBuzzTest and
;; http://en.wikipedia.org/wiki/Logical_disjunction.

;;; Code:

(require 'anaphora)

(defmacro sor (&rest conditions)
  "Eval all CONDITIONS for side effects, return first non-nil value.
 
Unlike `or' which evaluates the CONDITIONS until one yields
non-nil and then returns that value always evaluate all
CONDITIONS for side effects and only then return the first
non-nil value.  If all CONDITIONS return nil, return nil."
  (let ((ret (make-symbol "sor-value")))
    `(let (,ret)
       ,@(mapcar (lambda (c)
                   `(awhen ,c
                      (unless ,ret
                        (setq ,ret it))))
                 conditions)
       ,ret)))

(provide 'sor)
;; Local Variables:
;; indent-tabs-mode: nil
;; End:
;;; sor.el ends here
