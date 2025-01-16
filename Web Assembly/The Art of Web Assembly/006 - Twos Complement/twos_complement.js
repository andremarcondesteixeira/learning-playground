WebAssembly.instantiate(
    require("fs").readFileSync(`${__dirname}/twos_complement.wasm`)
).then(module => {
    var result = module.instance.exports.twos_complement(123);
    console.log(result);
});