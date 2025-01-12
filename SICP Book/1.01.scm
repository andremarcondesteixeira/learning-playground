10 ; evaluates to 10

(+ 5 3 4) ; evaluates to 12

(- 9 1) ; evaluates to 8

(/ 6 2) ; evaluates to 3

(+ (* 2 4) (- 4 6)) ; evaluates to 6

(define a 3) ; evaluates to the variable a, with value 3 (prints "a")

(define b (+ a 1)) ; evaluates to the variable b, with value 4 (prints "b")

(+ a b (* a b)) ; evaluates to 19

(= a b) ; evaluates to false (prints "#f")

(if (and (> b a) (< b (* a b)))
    a
    b) ; evaluates to 3

(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25)) ; evaluates to 16

(+ 2 (if (> b a) b a)) ; evaluates to 6

(* (cond ((> a b) a)
         ((< a b) b)
         (else -1))
   (+ a 1)) ; evaluates to 16
