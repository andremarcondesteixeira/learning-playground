(module
    (func $is_multiple (param $n1 i32) (param $n2 i32) (result i32)
        local.get $n1
        local.get $n2
        i32.rem_s
        i32.const 0
        i32.eq
    )

    (func (export "is_prime") (param $n i32) (result i32)
        (local $i i32)
        (local $max i32)

        (if (i32.le_s (local.get $n) (i32.const 1)) (then
            i32.const 0
            return
        ))

        (if (i32.eq (local.get $n) (i32.const 2)) (then
            i32.const 1
            return
        ))

        (if (call $is_multiple (local.get $n) (i32.const 2)) (then
            i32.const 0
            return
        ))
        
        (local.set $i (i32.const 1))
        (local.set $max (i32.div_s (local.get $n) (i32.const 2)))

        (loop $continue
            (local.set $i (i32.add (local.get $i) (i32.const 2)))
            (if (i32.ge_s (local.get $i) (local.get $max)) (then
                i32.const 1
                return
            ))
            (if (call $is_multiple (local.get $n) (local.get $i)) (then
                i32.const 0
                return
            ))
            br $continue
        )

        unreachable
        i32.const 0
    )
)