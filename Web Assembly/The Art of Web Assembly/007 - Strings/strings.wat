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