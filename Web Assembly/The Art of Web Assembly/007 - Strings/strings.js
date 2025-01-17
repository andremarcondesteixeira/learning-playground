const memory = new WebAssembly.Memory({ initial: 1 });
const maxMemory = 65535;

WebAssembly.instantiate(
    require("fs").readFileSync(`${__dirname}/strings.wasm`),
    {
        env: {
            memory,
            string_with_position_and_length(position, length) {
                const bytes = new Uint8Array(memory.buffer, position, length);
                const string = new TextDecoder("utf8").decode(bytes);
                console.log({ memory, bytes, position, length, string });
            },
            null_terminated_string(position) {
                const bytes = new Uint8Array(memory.buffer, position, maxMemory - position);
                const string = new TextDecoder("utf8").decode(bytes).split("\0")[0];
                console.log(string);
            },
            length_prefixed_string(position) {
                const length = new Uint8Array(memory.buffer, position, maxMemory - position)[0];
                const bytes = new Uint8Array(memory.buffer, position + 1, length);
                const string = new TextDecoder("utf8").decode(bytes);
                console.log(string);
            }
        }
    }
).then(module => module.instance.exports.main());