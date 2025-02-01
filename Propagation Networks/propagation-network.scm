(define nothing #(*the-nothing*))

(define (nothing? thing)
    (eq? thing nothing)
)

(define (content cell)
    (cell 'content)
)

(define (add-content cell increment)
    ((cell 'add-content) increment)
)

(define (new-neighbor! cell neighbor)
    ((cell 'new-neighbor!) neighbor)
)

(define (make-cell)
    (let
        ((neighbors '()) (content nothing))

        (define (add-content increment)
            (cond
                ((nothing? increment) 'ok)
                ((nothing? content)
                    (set! content increment)
                    (alert-propagators neighbors)
                )
                (else
                    (if (not (default-equal? content increment))
                        (error "Ack! Inconsistency!")
                    )
                )
            )
        )

        (define (new-neighbor! new-neighbor)
            (if (not (memq new-neighbor neighbors))
                (begin
                    (set! neighbors (cons new-neighbor neighbors))
                    (alert-propagator new-neighbor)
                )
            )
        )

        (define (me message)
            (cond
                ((eq? message 'content) content)
                ((eq? message 'add-content) add-content)
                ((eq? message 'new-neighbor!) new-neighbor!)
                (else (error "Unknown message" message))
            )
        )

        me
    )
)

(define (propagator neighbors to-do)
    (for-each
        (lambda (cell) (new-neighbor! cell to-do)) ;; apply this function
        (listify neighbors) ;; for each element in this list
    )
    (alert-propagator to-do)
)

(define (function->propagator-constructor f)
    (lambda cells
        (let
            (
                (output (car (last-pair cells)))
                (inputs (except-last-pair cells))
            )
            (propagator  ; The output isn’t a neighbor!
                inputs
                (lambda ()
                    (add-content output (apply f (map content inputs)))
                )
            )
        )
    )
)

(define (handling-nothings f)
    (lambda args
        (if (any nothing? args)
            nothing
            (apply f args)
        )
    )
)

(define adder (function->propagator-constructor (handling-nothings +)))
(define subtractor (function->propagator-constructor (handling-nothings -)))
(define multiplier (function->propagator-constructor (handling-nothings *)))
(define divider (function->propagator-constructor (handling-nothings /)))
(define (constant value) (function->propagator-constructor (lambda () value)))

 (define (fahrenheit->celsius f c) (
    let (
        (thirty-two (make-cell))
        (f-32 (make-cell))
        (five (make-cell))
        (c*9 (make-cell))
        (nine (make-cell))
    )
    ((constant 32) thirty-two)
    ((constant 5) five)
    ((constant 9) nine)
    (subtractor f thirty-two f-32)
    (multiplier f-32 five c*9)
    (divider c*9 nine c)
))

(define f (make-cell))
(define c (make-cell))
(fahrenheit->celsius f c)
(add-content f 77)
(content c)
