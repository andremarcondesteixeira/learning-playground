const fs = require("fs");
const bytes = fs.readFileSync(`${__dirname}/hello_world.wasm`);
let start_string = 100;
let memory = new WebAssembly.Memory({ initial: 1 });
let import_object = {
    env: {
        memory,
        start_string,
        print_string(str_len) {
            const bytes = new Uint8Array(memory.buffer, start_string, str_len);
            const log_string = new TextDecoder("utf8").decode(bytes);
            console.log(log_string);
        }
    }
};

WebAssembly.instantiate(new Uint8Array(bytes), import_object).then(obj => {
    obj.instance.exports.hello_world();
});
