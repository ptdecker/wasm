// JavaScript Test Harness for Pure Checkers WASM
//
// Based on wasmcheckers/func_test.js from p. 29 of Kevin Hoffman's "Programming WebAssembly With Rust"
// but with the following changes:
//
// - Added test_eq() to simplify test harness

function test_eq(test_name, test_func, expected) {
	let got = test_func();
	if (got === expected) {
	  console.log('%c PASS ', 'background: #008000; color: #FFFFFF', `${test_name}: Expected ${expected}, got ${got}`);
	} else {
	  console.log('%c FAIL ', 'background: #FF0000; color: #FFFFFF', `${test_name}: Expected ${expected}, got ${got}`);
	}
}


console.log("Starting tests");
fetch('./checkers.wasm')
	.then(response => response.arrayBuffer())
  .then(bytes => WebAssembly.instantiate(bytes))
  .then(results => {

		instance = results.instance;
		checkers = instance.exports;

		console.log("Loaded WASM module");
		console.log("Instance", instance);

		var black = 1;
		var white = 2;
		var crowned_black = 5;
		var crowned_white = 6;

		test_eq("Offset for (3,4)", () => checkers.offsetForPosition(3, 4), 140);
		test_eq("Black is black?", () => checkers.isBlack(black), 1);
		test_eq("White is white?", () => checkers.isWhite(white), 1);
		test_eq("Black is white?", () => checkers.isWhite(black), 0);
		test_eq("White is black?", () => checkers.isBlack(white), 0);
		test_eq("Uncrowned white", () => checkers.isWhite(instance.exports.withoutCrown(crowned_white)), 1);
		test_eq("Uncrowned black", () => checkers.isBlack(instance.exports.withoutCrown(crowned_black)), 1);
		test_eq("Crowned black is crowned", () => checkers.isCrowned(crowned_black), 1);
		test_eq("Crowned white is crowned", () => checkers.isCrowned(crowned_white), 1);
	});

