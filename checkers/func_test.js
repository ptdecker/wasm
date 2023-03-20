// JavaScript Test Harness for Pure Checkers WASM
//
// Based on wasmcheckers/func_test.js from p. 29 of Kevin Hoffman's "Programming WebAssembly With Rust"
// but with the following changes:
//
// - Added test_eq() to simplify test harness
// - Changed to leverage exported piece values instead of values defined locally

function test_eq(test_name, got, expected) {
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

		const black = checkers.BLACK.value;
		const white = checkers.WHITE.value;
		const crownedBlack = black + checkers.CROWN.value;
		const crownedWhite = white + checkers.CROWN.value;

		test_eq("Offset for (3,4)", checkers.offsetForPosition(3, 4), 140);
		test_eq("Black is black?", checkers.isBlack(black), 1);
		test_eq("White is white?", checkers.isWhite(white), 1);
		test_eq("Black is white?", checkers.isWhite(black), 0);
		test_eq("White is black?", checkers.isBlack(white), 0);
		test_eq("Uncrowned white", checkers.isWhite(instance.exports.withoutCrown(crownedWhite)), 1);
		test_eq("Uncrowned black", checkers.isBlack(instance.exports.withoutCrown(crownedBlack)), 1);
		test_eq("Crowned black is crowned", checkers.isCrowned(crownedBlack), 1);
		test_eq("Crowned white is crowned", checkers.isCrowned(crownedWhite), 1);
		checkers.setPiece(3, 4, black);
		test_eq("Storing black at (3,4)", checkers.getPiece(3, 4), black);
		checkers.setPiece(3, 5, white);
		test_eq("Storing white at (3,5)", checkers.getPiece(3, 5), white);
	});

