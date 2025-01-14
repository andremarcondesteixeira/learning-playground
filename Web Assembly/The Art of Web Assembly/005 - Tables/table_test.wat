(module
    (import "js" "tbl" (table $tbl 4 funcref))
    (import "js" "js_increment" (func $js_increment (result i32)))
    (import "js" "js_decrement" (func $js_decrement (result i32)))
    (import "js" "wasm_increment" (func $wasm_increment (result i32)))
    (import "js" "wasm_decrement" (func $wasm_decrement (result i32)))
    
    (type $returns_i32 (func (result i32)))
    
    (global $inc_ptr i32 (i32.const 0))
    (global $dec_ptr i32 (i32.const 1))
    (global $wasm_inc_ptr i32 (i32.const 2))
    (global $wasm_dec_ptr i32 (i32.const 3))
    
    ;; Test performance of an indirect table call of javascript functions
    (func (export "js_table_test")
        (loop $inc_cycle
            (call_indirect (type $returns_i32) (global.get $inc_ptr))
            i32.const 4000000
            i32.le_u
            br_if $inc_cycle
        )

        (loop $dec_cycle
            (call_indirect (type $returns_i32) (global.get $dec_ptr))
            i32.const 4000000
            i32.le_u
            br_if $dec_cycle
        )
    )

    ;; Test performance of direct call to javascript functions
    (func (export "js_import_test")
        (loop $inc_cycle
            call $js_increment
            i32.const 4000000
            i32.le_u
            br_if $inc_cycle
        )

        (loop $dec_cycle
            call $js_decrement
            i32.const 4000000
            i32.le_u
            br_if $dec_cycle
        )
    )

    ;; Test performance of indirect table call of WASM functions
    (func (export "wasm_table_test")
        (loop $inc_cycle
            (call_indirect (type $returns_i32) (global.get $wasm_inc_ptr))
            i32.const 4000000
            i32.le_u
            br_if $inc_cycle
        )

        (loop $dec_cycle
            (call_indirect (type $returns_i32) (global.get $wasm_dec_ptr))
            i32.const 4000000
            i32.le_u
            br_if $dec_cycle
        )
    )

    ;; Test performance of direct call to WASM functions
    (func (export "wasm_import_test")
        (loop $inc_cycle
            call $wasm_increment
            i32.const 4000000
            i32.le_u
            br_if $inc_cycle
        )

        (loop $dec_cycle
            call $wasm_decrement
            i32.const 4000000
            i32.le_u
            br_if $dec_cycle
        )
    )
)