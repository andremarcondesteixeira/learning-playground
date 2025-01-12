WebAssembly.instantiate(
    require("fs").readFileSync(`${__dirname}/loop.wasm`),
    {
        env: {
            log(n, factorial) {
                console.log(`${n}! = ${factorial}`);
            }
        }
    }
).then(module => {
    module.instance.exports.loop_test(parseInt(process.argv[2] || "1"));
});
