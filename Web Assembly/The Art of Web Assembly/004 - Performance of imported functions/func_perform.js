let i = 0;

WebAssembly.instantiate(
    require("fs").readFileSync(`${__dirname}/func_perform.wasm`),
    {
        js: {
            external_call() {
                i++;
                return i;
            }
        }
    }
).then(module => {
    const wasm_call = module.instance.exports.wasm_call;
    const js_call = module.instance.exports.js_call;

    let start = Date.now();
    js_call();
    let time = Date.now() - start;
    console.log(`js_call time: ${time}`);

    start = Date.now();
    wasm_call();
    time = Date.now() - start;
    console.log(`wasm_call time: ${time}`);
});