(define (A x y)
    (cond
        ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else
            (A (- x 1) (A x (- y 1)))
        )
    )
)

; (A 1 10)
; (A (- 1 1) (A 1 (- 10 1)))
; (A 0 (A 1 9))
; (A 0 (A (- 1 1) (A 1 (- 9 1))))
; (A 0 (A 0 (A 1 8)))
; (A 0 (A 0 (A (- 1 1) (A 1 (- 8 1)))))
; (A 0 (A 0 (A 0 (A 1 7)))) ; <--------------------------------------- Ok, there is pattern here
; (A 0 (A 0 (A 0 (A 0 (A 1 6)))))
; (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 5))))))
; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 4)))))))
; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 3))))))))
; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 2)))))))))
; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 1)))))))))) ; <--- Now y is 1
; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 2)))))))))
; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 4))))))))
; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 8)))))))
; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 16))))))
; (A 0 (A 0 (A 0 (A 0 (A 0 32)))))
; (A 0 (A 0 (A 0 (A 0 64))))
; (A 0 (A 0 (A 0 128)))
; (A 0 (A 0 256))
; (A 0 512)
; 1024 ; <------------------------------------------------------------ That was a linear recursive process


; (A 2 4)
; (A (- 2 1) (A 2 (- 4 1)))
; (A 1 (A 2 3))
; (A 1 (A (- 2 1) (A 2 (- 3 1))))
; (A 1 (A 1 (A 2 2)))
; (A 1 (A 1 (A (- 2 1) (A 2 (- 2 1)))))
; (A 1 (A 1 (A 1 (A 2 1))))
; (A 1 (A 1 (A 1 2))) ; <--------------------------------------------- (A 1 2) was used in line 23, and it's result was 4
; (A 1 (A 1 4)) ; <--------------------------------------------------- (A 1 4) was used in line 21, and it's result was 16
; (A 1 16) ; <-------------------------------------------------------- Now I'll keep following the expansion pattern found in the first expression (line 12)
; (A 0 (A 1 15))
; (A 0 (A 0 (A 1 14)))
; (A 0 (A 0 (A 0 (A 1 13))))
; (A 0 (A 0 (A 0 (A 0 (A 1 12)))))
; (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 11))))))
; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 10))))))) ; <-------------------- (A 1 10) was used in line 12, and it's result was 1024
; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 1024))))))
; (A 0 (A 0 (A 0 (A 0 (A 0 2048)))))
; (A 0 (A 0 (A 0 (A 0 4096))))
; (A 0 (A 0 (A 0 8192)))
; (A 0 (A 0 16384))
; (A 0 32768)
; 65536

; (A 3 3)
; (A (- 3 1) (A 3 (- 3 1)))
; (A 2 (A 3 2))
; (A 2 (A (- 3 1) (A 3 (- 2 1))))
; (A 2 (A 2 (A 3 1)))
; (A 2 (A 2 2)) ; <--------------------------------------------------- (A 2 2) was used in line 41, and it's result was 4
; (A 2 4) ; <--------------------------------------------------------- (A 2 4) was used in line 37, and it's result was 65536
; 65536

(define (f n) (A 0 n)) ; returns 2 * n

(define (g n) (A 1 n)) ; if n is 0 returns 0, if n < 0 exceeds maximum recursion depth, if > 0 returns 2 to the power of n

(define (h n) (A 2 n)) ; if n is 0 returns 0, if n < 0 exceeds maximum recursion depth, if > 0 returns 2 to the power of (h (- n 1))
