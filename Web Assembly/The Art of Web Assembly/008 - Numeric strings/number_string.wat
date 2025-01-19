(module
    (import "env" "print_string" (func $print_string (param i32 i32)))
    (import "env" "memory" (memory 1))
    
    (data (i32.const 128) "0123456789ABCDEF")
    (data (i32.const 256) "               0")
    (global $decimal_string_length i32 (i32.const 16))

    ;; suppose $number = 123, $string_length = 3
    (func $set_decimal_string (param $number i32) (param $string_length i32)
        (local $index i32)
        (local $digit_character i32)
        (local $digit_value i32)

        local.get $string_length ;; stack = [3]
        local.set $index         ;; stack = [], $index = 3

        local.get $number        ;; stack = [123]
        i32.eqz                  ;; stack = [0], eqz means "equal to zero"

        if                       ;; stack = [], if the number is zero, save ascii "0" to memory
            local.get $index     ;; stack = [3]
            i32.const 1          ;; stack = [3, 1]
            i32.sub              ;; stack = [2]
            local.set $index     ;; stack = [], $index = 2

            (i32.store8 offset=256 (local.get $index) (i32.const 48)) ;; save ascii "0" to memory address 256 + index
            ;; Explanation for the the line of code above:
            ;; i32.store8 stores in the memory the least significant byte of (i32.const 48)
            ;; The memory address where the value will be stored is (local.get $index) plus the offset=256
        end

        (loop $digit_loop (block $break      ;; FIRST ITERATION         | SECOND ITERATION        | THIRD ITERATION         | FOURTH ITERATION
            local.get $index                 ;; stack = [3]             | stack = [2]             | stack = [1]             | stack = [0]
            i32.eqz                          ;; stack = [0]             | stack = [0]             | stack = [0]             | stack = [1]
            br_if $break                     ;; stack = []              | stack = []              | stack = []              | stack = [] BREAKS
                                             ;;                         |                         |                         |
            local.get $number                ;; stack = [123]           | stack = [12]            | stack = [1]             |
            i32.const 10                     ;; stack = [123, 10]       | stack = [12, 10]        | stack = [1, 10]         |
            i32.rem_u                        ;; stack = [3]             | stack = [2]             | stack = [1]             |
                                             ;;                         |                         |                         |
            local.set $digit_value           ;; stack = []              | stack = []              | stack = []              |
                                             ;; $digit_value = 3        | $digit_value = 2        | $digit_value = 1        |
            local.get $number                ;; stack = [123]           | stack = [12]            | stack = [1]             |
            i32.eqz                          ;; stack = [0]             | stack = [0]             | stack = [0]             |
                                             ;;                         |                         |                         |
            if                               ;; stack = []              | stack = []              | stack = []              |
                i32.const 32                 ;;                         |                         |                         |
                local.set $digit_character   ;; stack = []              |                         |                         |
                ;; 32 is " " in ASCII        ;;                         |                         |                         |
                                             ;;                         |                         |                         |
            else                             ;;                         |                         |                         |
                (i32.load8_u                 ;;                         |                         |                         |
                    offset=128               ;;                         |                         |                         |
                    (local.get $digit_value) ;; stack = [3]             | stack = [2]             | stack = [1]             |
                )                            ;; stack = ["3"]           | stack = ["2"]           | stack = ["1"]           |
                ;; The line above puts on the stack 1 byte of memory from memory address ofsset=128 + $digit_value          |
                local.set $digit_character   ;; stack = []              | stack = []              | stack = []              |
                                             ;; $digit_character = "3"  | $digit_character = "2"  | $digit_character = "1"  |
            end                              ;;                         |                         |                         |
                                             ;;                         |                         |                         |
            local.get $index                 ;; stack = [3]             | stack = [2]             | stack = [1]             |
            i32.const 1                      ;; stack = [3, 1]          | stack = [2, 1]          | stack = [1, 1]          |
            i32.sub                          ;; stack = [2]             | stack = [1]             | stack = [0]             |
            local.set $index                 ;; stack = []              | stack = []              | stack = []              |
                                             ;; $index = 2              | $index = 1              | $index = 0              |
                                             ;;                         |                         |                         |
            (i32.store8                      ;; memory at 256 is        | memory at 256 is        | memory at 256 is        |
                offset=256                   ;; "               0"      | "  3            0"      | " 23            0"      |
                (local.get $index)           ;; then is                 | then is                 | then is                 |
                (local.get $digit_character) ;; "  3            0"      | " 23            0"      | "123            0"      |
            )                                ;;                         |                         |                         |
            ;; the instruction above stores 1 byte of data in the memory address $index. Data is $digit_character           |
                                             ;;                         |                         |                         |
            local.get $number                ;; stack = [123]           | stack = [12]            | stack = [1]             |
            i32.const 10                     ;; stack = [123, 10]       | stack = [12, 10]        | stack = [1, 10]         |
            i32.div_u                        ;; stack = [12]            | stack = [1]             | stack = [0]             |
            local.set $number                ;; stack = []              | stack = []              | stack = []              |
                                             ;; $number = 12            | $number = 1             | $number = 0             |
                                             ;;                         |                         |                         |
            br $digit_loop                   ;;                         |                         |                         |
        ))                                   ;;                         |                         |                         |
    )                                        ;;                         |                         |                         |

    (func (export "to_string") (param $number i32)
        (call $set_decimal_string (local.get $number) (global.get $decimal_string_length))
        (call $print_string (i32.const 256) (global.get $decimal_string_length))
    )
)