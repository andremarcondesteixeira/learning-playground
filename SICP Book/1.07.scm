; when the input number is big enough, the limited
; precision makes the improve function to keep returning
; the same number in some cases, and this returned number
; is not considered good enough, resulting in an infinite
; loop

; when the input is small enough, it will be smaller than
; the tolerance of 0.001, so the sqrt-iter function returns
; incorrect results

; One solution is to make the good-enough? function check
; if th improve function has reached the limits of precision.
; We know the precision is at its limit when the result of
; the improve function is the same as the previous call

(define (good-enough? guess x)
    (= (improve guess x) guess))

(define (average x y)
    (/ (+ x y) 2))

(define (improve guess x)
    (average guess (/ x guess)))

(define (sqrt-iter guess x)
    (newline)
    (display guess)
    (if (good-enough? guess x)
        guess
        (sqrt-iter (improve guess x) x)))

(define (sqrt x) (sqrt-iter 1.0 x))

(sqrt 10000000000000)
