(module
    (import "env" "string_with_position_and_length" (func $string_with_position_and_length (param i32 i32)))
    (import "env" "null_terminated_string" (func $null_terminated_string (param i32)))
    (import "env" "length_prefixed_string" (func $length_prefixed_string (param i32)))
    (import "env" "memory" (memory 1))

    (data (i32.const 0) "Know the length of this string")
    (data (i32.const 30) "Also know the length of this string")
    (data (i32.const 65) "null-terminating string \00")
    (data (i32.const 90) "another null-terminating string\00")
    (data (i32.const 122) "\16length-prefixed string")
    (data (i32.const 145) "\1eanother length-prefixed string")
    
    ;; suppose $source is 100, $dest is 200 and $len is 10
    (func $byte_copy (param $source i32) (param $dest i32) (param $len i32)
        (local $last_source_byte i32)

        local.get $source ;; stack = [100]
        local.get $len    ;; stack = [100, 10]
        i32.add           ;; stack = [110]

        local.set $last_source_byte ;; stack = [], $last_source_byte = 110

        (loop $copy_loop (block $break
            local.get $dest                   ;; stack = [200]
            (i32.load8_u (local.get $source)) ;; stack = [200, 100] then [200, {byte at $source}]
            i32.store8                        ;; stack = [], memory is changed (the copy is effectively made here)

            local.get $dest ;; stack = [200]
            i32.const 1     ;; stack = [200, 1]
            i32.add         ;; stack = [201]
            local.set $dest ;; stack = [], $dest = 201

            local.get $source ;; stack = [100]
            i32.const 1       ;; stack = [100, 1]
            i32.add           ;; stack = [101]
            local.tee $source ;; stack = [101], $source = 101

            local.get $last_source_byte ;; stack = [101, 110]
            i32.eq                      ;; stack = [0]
            br_if $break
            br $copy_loop
        ))
    )
    
    (func (export "main")
        ;; length of the first string is 30 characters
        (call $string_with_position_and_length (i32.const 0) (i32.const 30))
        
        ;; length of the second string is 35 characters
        (call $string_with_position_and_length (i32.const 30) (i32.const 35))

        (call $null_terminated_string (i32.const 65))
        (call $null_terminated_string (i32.const 90))

        (call $length_prefixed_string (i32.const 122))
        (call $length_prefixed_string (i32.const 145))
    )
)