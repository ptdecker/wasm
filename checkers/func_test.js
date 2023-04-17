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
  .then(bytes => WebAssembly.instantiate(bytes, {
    events: {
      piececrowned: (x, y) => {
        console.log(`A piece was crowned at (${x}, ${y})`);
      }
    },
  }))
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
    checkers.setTurnOwner(black);
    test_eq("Black should be turn owner", checkers.getTurnOwner(), black);
    checkers.toggleTurnOwner();
    test_eq("After toggle, white should be turn owner", checkers.getTurnOwner(), white);
    test_eq("It should now be white's turn", checkers.isPlayersTurn(white), 1);
    test_eq("And, not black's turn", checkers.isPlayersTurn(black), 0);
    checkers.toggleTurnOwner();
    test_eq("After toggling it should now be black's turn", checkers.isPlayersTurn(black), 1);
    test_eq("And, no longer white's turn", checkers.isPlayersTurn(white), 0);
    test_eq("Black on row 0, should be crowned", checkers.shouldCrown(0, black), 1);
    test_eq("White on row 0, should not be crowned", checkers.shouldCrown(0, white), 0);
    test_eq("Black on row 7, should not be crowned", checkers.shouldCrown(7, black), 0);
    test_eq("Black on row 7, should be crowned", checkers.shouldCrown(7, white), 1);
    test_eq("Black on row 3, should not be crowned", checkers.shouldCrown(3, black), 0);
    test_eq("White on row 3, should not be crowned", checkers.shouldCrown(3, white), 0);
    checkers.setPiece(0, 0, black);
    test_eq("Before crowning black at (0,0)", checkers.getPiece(0, 0), black);
    checkers.crownPiece(0, 0);
    test_eq("After crowning black at (0,0)", checkers.getPiece(0, 0), crownedBlack);
    test_eq("There shouldn't be a piece yet at (7,7)", checkers.getPiece(7, 7), 0);
    test_eq("So, if we try to move the non-existant piece it should be invalid", checkers.isValidMove(7,7,7,6), 0);
    checkers.setPiece(7, 7, black);
    test_eq("We will put a black one there at (7,7)", checkers.getPiece(7, 7), black);
    checkers.setTurnOwner(white);
    test_eq("But we will set the turn owner to white", checkers.getTurnOwner(), white);
    test_eq("So, we still shouldn't be able to move black at (7,7)", checkers.isValidMove(7,7,7,6), 0);
    checkers.toggleTurnOwner();
    test_eq("However if we toggle the turn owner to black", checkers.getTurnOwner(), black);
    test_eq("It should now be valid to move black at (7,7) to (7,6)", checkers.isValidMove(7,7,7,6), 1);
    test_eq("And, from (7,7) to (7,5)", checkers.isValidMove(7,7,7,5), 1);
    test_eq("But, not from (7,7) to (7,4)", checkers.isValidMove(7,7,7,4), 0);
  });

