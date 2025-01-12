(define (p) (p))
(define (test x y)
        (if (= x 0) 0 y))
(test 0 (p))

; in normal order, the compiler will do the following steps:
;       (test 0 (p))
;       (if (= 0 0) 0 (p))
;       0
;
; in applicative order, the compiler will try to evaluate (p) on (test o (p))
; and since (p) is a recursive definition, it will never terminate
