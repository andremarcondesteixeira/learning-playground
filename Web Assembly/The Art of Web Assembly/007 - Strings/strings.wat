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
    
    ;; Suppose $source_address is 100, $destination_address is 200 and $length is 10
    (func $byte_copy (param $source_address i32) (param $destination_address i32) (param $length i32)
        (local $last_address i32)

        local.get $source_address                     ;; stack = [100]
        local.get $length                             ;; stack = [100, 10]
        i32.add                                       ;; stack = [110]

        local.set $last_address                       ;; stack = [], $last_address = 110

        (loop $copy_loop (block $break
            local.get $destination_address            ;; stack = [200]
            (i32.load8_u (local.get $source_address)) ;; stack = [200, 100] then [200, {byte at $source_address}]
            i32.store8                                ;; stack = [], memory is changed (the copy is effectively made here)

            local.get $destination_address            ;; stack = [200]
            i32.const 1                               ;; stack = [200, 1]
            i32.add                                   ;; stack = [201]
            local.set $destination_address            ;; stack = [], $destination_address = 201

            local.get $source_address                 ;; stack = [100]
            i32.const 1                               ;; stack = [100, 1]
            i32.add                                   ;; stack = [101]
            local.tee $source_address                 ;; stack = [101], $source_address = 101

            local.get $last_address                   ;; stack = [101, 110]
            i32.eq                                    ;; stack = [0]
            br_if $break                              ;; stack = []
            br $copy_loop
        ))
    )

    ;; Suppose $source_address = 100, $destination_address = 200, $length = 10
    (func $i64_copy (param $source_address i32) (param $destination_address i32) (param $length i32)
        (local $last_address i32)

        local.get $source_address ;; stack = [100]
        local.get $length         ;; stack = [100, 10]
        i32.add                   ;; stack = [110]

        local.set $last_address   ;; stack = [], $last_address = 110

        (loop $copy_loop (block $break
            ;; Explanation for the code line below:
            ;; First, (local.get $destination_address) puts $destination_address in the stack: [$destination_address]
            ;; Then, (local.get $source_address) puts $source_address in the stack: [$destination_address, $source_address]
            ;; Then, i64.load consumes the value in the top of the stack ($source_address),
            ;;      and reads an i64 (8 bytes of memory) from the location $source_address
            ;;      and puts the result in the top of the stack:
            ;;      [$destination_address, i64 from memory location at $source_address]
            ;; Then, i64.store consumes two values from the top of the stack,
            ;;      saving i64 from memory location at $source_address to memory location at $destination_address
            ;; At this point, 8 bytes of memory were copied
            (i64.store (local.get $destination_address) (i64.load (local.get $source_address)))
            

            local.get $destination_address ;; stack = [200]
            i32.const 8                    ;; stack = [200, 8]
            i32.add                        ;; stack = [208]
            local.set $destination_address ;; stack = [], $destination_address = 208

            local.get $source_address      ;; stack = [100]
            i32.const 8                    ;; stack = [100, 108]
            i32.add                        ;; stack = [108]
            local.tee $source_address      ;; stack = [108], $source_address = 108

            local.get $last_address        ;; stack = [108, 110]
            i32.ge_u                       ;; stack = [0]

            br_if $break                   ;; stack = []
            br $copy_loop
        ))
    )

    ;; suppose $source_address = 100, $destination_address = 200, $length = 10
    (func $string_copy (param $source_address i32) (param $destination_address i32) (param $length i32)
        (local $start_source_address i32)
        (local $start_destination_address i32)
        (local $singles i32)
        (local $remaining_bytes i32)

        local.get $length                        ;; stack = [10]
        local.set $remaining_bytes               ;; stack = [], $remaining_bytes = 10

        local.get $length                        ;; stack = [10]
        i32.const 7                              ;; stack = [10, 7]
        ;; stack here can be represented in binary numbers, to understand the and operation below:
        ;; stack:
        ;;      00000000000000000000000000001010 -> 10
        ;;      00000000000000000000000000000111 -> 7
        ;; and  ________________________________
        ;;      00000000000000000000000000000010 -> 2
        i32.and                                  ;; stack = [2]
        local.tee $singles                       ;; stack = [2], $singles = 2

        if                                       ;; stack = []
            local.get $length                    ;; stack = [10]
            local.get $singles                   ;; stack = [10, 2]
            i32.sub                              ;; stack = [8]
            local.tee $remaining_bytes           ;; stack = [8], $remaining_bytes = 8

            local.get $source_address            ;; stack = [8, 100]
            i32.add                              ;; stack = [108]
            local.set $start_source_address      ;; stack = [], $start_source_address = 108

            local.get $remaining_bytes           ;; stack = [8]
            local.get $destination_address       ;; stack = [8, 200]
            i32.add                              ;; stack = [208]
            local.set $start_destination_address ;; stack = [], $start_destination_address = 208

            ;; stack steps for the code line below:
            ;;      [108]
            ;;      [108, 208]
            ;;      [108, 208, 2]
            ;;      []
            (call $byte_copy (local.get $start_source_address) (local.get $start_destination_address) (local.get $singles))
        end

        local.get $length                        ;; stack = [10]
        i32.const 0xfffffff8                     ;; stack = [10, 4294967288]
        ;; binary representation of the stack to understant the and operation below:
        ;;      00000000000000000000000000001010 -> 10
        ;;      11111111111111111111111111111000 -> 0xfffffff8 -> 4294967288
        ;; and  ________________________________
        ;;      00000000000000000000000000001000 -> 8
        i32.and                                  ;; stack = [8]
        local.set $length                        ;; stack = [], $length = 8
        (call $i64_copy (local.get $source_address) (local.get $destination_address) (local.get $length))
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

        (call $string_copy (i32.const 30) (i32.const 200) (i32.const 35))
        (call $string_with_position_and_length (i32.const 200) (i32.const 35))
    )
)