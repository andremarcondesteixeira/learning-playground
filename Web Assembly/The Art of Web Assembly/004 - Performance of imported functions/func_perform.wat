(module
    (import "js" "external_call" (func $external_call (result i32)))
    (global $i (mut i32) (i32.const 0))
    (func $internal_call (result i32)
        global.get $i ;; stack = [$i]
        i32.const 1   ;; stack = [$i, 1]
        i32.add       ;; stack = [$i+1]
        global.set $i ;; stack = []
        global.get $i ;; stack = [$i]
    )
    (func (export "wasm_call")
        (loop $again
            call $internal_call ;; stack = [$i]
            i32.const 4000000   ;; stack = [$i, 4000000]
            i32.le_u            ;; stack = [1]
            br_if $again
        )
    )
    (func (export "js_call")
        (loop $again
            call $external_call
            i32.const 4000000
            i32.le_u
            br_if $again
        )
    )
)