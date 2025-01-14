(module
    (import "js" "js_increment" (func $js_increment (result i32)))
    (import "js" "js_decrement" (func $js_decrement (result i32)))
    (table $tbl (export "tbl") 4 funcref)
    (global $i (mut i32) (i32.const 0))
    (func $wasm_increment (export "wasm_increment") (result i32)
        (global.set $i (i32.add (global.get $i) (i32.const 1)))
        global.get $i
    )
    (func $wasm_decrement (export "wasm_decrement") (result i32)
        (global.set $i (i32.sub (global.get $i) (i32.const 1)))
        global.get $i
    )
    (elem (i32.const 0) $js_increment $js_decrement $wasm_increment $wasm_decrement)
)