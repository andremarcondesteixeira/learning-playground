let i = 0;

const js_increment = () => ++i;
const js_decrement = () => --i;

WebAssembly.instantiate(
    require("fs").readFileSync(`${__dirname}/table_export.wasm`),
    {
        js: {
            js_increment,
            js_decrement,
        }
    }
).then(table_export => {
    WebAssembly.instantiate(
        require("fs").readFileSync(`${__dirname}/table_test.wasm`),
        {
            js: {
                js_increment,
                js_decrement,
                tbl: table_export.instance.exports.tbl,
                wasm_increment: table_export.instance.exports.wasm_increment,
                wasm_decrement: table_export.instance.exports.wasm_decrement,
            }
        }
    ).then(table_test => {
        const js_table_test = table_test.instance.exports.js_table_test;
        const js_import_test = table_test.instance.exports.js_import_test;
        const wasm_table_test = table_test.instance.exports.wasm_table_test;
        const wasm_import_test = table_test.instance.exports.wasm_import_test;

        let start = Date.now();
        js_table_test();
        let time = Date.now() - start;
        console.log(`js_table_test time: ${time}`);

        start = Date.now();
        js_import_test();
        time = Date.now() - start;
        console.log(`js_import_test time: ${time}`);

        start = Date.now();
        wasm_table_test();
        time = Date.now() - start;
        console.log(`wasm_table_test time: ${time}`);

        start = Date.now();
        wasm_import_test();
        time = Date.now() - start;
        console.log(`wasm_import_test time: ${time}`);
    })
});