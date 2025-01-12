WebAssembly.instantiate(
    require("fs").readFileSync(`${__dirname}/is_prime.wasm`)
).then(module => {
    const is_prime = module.instance.exports.is_prime;

    console.log(`-1 is prime?`, is_prime(-1));
    console.log(`0 is prime?`, is_prime(0));
    console.log(`1 is prime?`, is_prime(1));
    console.log(`2 is prime?`, is_prime(2));
    console.log(`3 is prime?`, is_prime(3));
    console.log(`4 is prime?`, is_prime(4));
    console.log(`5 is prime?`, is_prime(5));
    console.log(`6 is prime?`, is_prime(6));
    console.log(`7 is prime?`, is_prime(7));
    console.log(`8 is prime?`, is_prime(8));
    console.log(`9 is prime?`, is_prime(9));
    console.log(`10 is prime?`, is_prime(10));
    console.log(`11 is prime?`, is_prime(11));
    console.log(`12 is prime?`, is_prime(12));
    console.log(`13 is prime?`, is_prime(13));
});
