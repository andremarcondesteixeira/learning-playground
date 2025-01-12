(define (a-plus-abs-b a b)
        ((if (> b 0) + -) a b))

(a-plus-abs-b 2 -2)

; the a-plus-abs-b function will apply a different operator wheter b is negative or not
; example:
;   (a-plus-abs-b 2 -2)
;   since b < 0, then (if (> b 0) + -) evaluates to - (minus), then:
;   (- 2 -2)
;   which evaluates to 2 - -2 = 4
