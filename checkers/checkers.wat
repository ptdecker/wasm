;; Pure WASM Checkers Implementation
;;
;; Based on wasmcheckers/func_test.wat on p. 27 of Kevin Hoffman's "Programming WebAssembly
;; with Rust" with the following modificaitons:
;;
;; - Replaced deprecated `get_local` with local.get
;; - Replaced deprecated `get_global` with global.get
;; - Replace power of two multiplications with left bit shifts
;; - Moved exports into function definitions
;; - Added export of piece type identifiers as globals

(module

  ;; Imports
  (import "events" "piececrowned"
    (func $notify_piececrowned (param $pieceX i32) (param $pieceY i32)))

  ;; Allocate memory
  (memory $men 1)

   ;; Globals
  (global $BLACK (export "BLACK") i32 (i32.const 1))
  (global $WHITE (export "WHITE") i32 (i32.const 2))
  (global $CROWN (export "CROWN") i32 (i32.const 4))
  (global $currentTurn (mut i32) (i32.const 0))

 ;; offsetForPosition = 4 * indexForPosition [4 * ((8 * x) + y)]
  (func $offsetForPosition (export "offsetForPosition") (param $x i32) (param $y i32) (result i32)
    (i32.shl
      (i32.add
        (i32.shl
          (local.get $y)
          (i32.const 3)
        )
        (local.get $x)
      )
      (i32.const 2)
    )
  )

  ;; Determine if a piece has been crowned
  (func $isCrowned (export "isCrowned") (param $piece i32) (result i32)
    (i32.eq
      (i32.and (local.get $piece) (global.get $CROWN))
      (global.get $CROWN)
    )
  )
  
  ;; Determine if a piece is white
  (func $isWhite (export "isWhite") (param $piece i32) (result i32)
    (i32.eq
      (i32.and (local.get $piece) (global.get $WHITE))
      (global.get $WHITE)
    )
  )
  
  ;; Determine if a piece is black
  (func $isBlack (export "isBlack") (param $piece i32) (result i32)
    (i32.eq
      (i32.and (local.get $piece) (global.get $BLACK))
      (global.get $BLACK)
    )
  )

  ;; Adds a crown to a given piece (no mutation)
  (func $withCrown (export "withCrown") (param $piece i32) (result i32)
    (i32.or (local.get $piece) (global.get $CROWN))
  )

  ;; Removes a crown from a given piece (no mutation)
  (func $withoutCrown (export "withoutCrown") (param $piece i32) (result i32)
    (i32.and (local.get $piece) (i32.const 3))
  )
  
  ;; Set a piece on the board
  (func $setPiece (export "setPiece") (param $x i32) (param $y i32) (param $piece i32)
    (i32.store
      (call $offsetForPosition (local.get $x) (local.get $y))
      (local.get $piece)
    )
  )

  ;; Gets a piece from the board. Out of range causes a trap
  (func $getPiece (export "getPiece") (param $x i32) (param $y i32) (result i32)
    (if (result i32)
      (block (result i32)
        (i32.and
          (call $inRange (i32.const 0) (i32.const 7) (local.get $x))
          (call $inRange (i32.const 0) (i32.const 7) (local.get $y))
        ))
    (then
      (i32.load
        (call $offsetForPosition (local.get $x) (local.get $y))
      ))
    (else
      (unreachable))
    )
  )

  ;; Detect if values are within a range (inclusive high and low)
  (func $inRange (param $low i32) (param $high i32) (param $value i32) (result i32)
    (i32.and
      (i32.ge_s (local.get $value) (local.get $low))
      (i32.le_s (local.get $value) (local.get $high))
    )
  )

  ;; Get the current turn owner
  (func $getTurnOwner (export "getTurnOwner") (result i32)
    (global.get $currentTurn)
  )

  ;; At the end of a turn, switch turn owner to the other player
  (func $toggleTurnOwner (export "toggleTurnOwner")
    (if (i32.eq (call $getTurnOwner) (i32.const 1))
      (then (call $setTurnOwner (i32.const 2)))
      (else (call $setTurnOwner (i32.const 1)))
    )
  )

  ;; Set the turn owner
  (func $setTurnOwner (export "setTurnOwner") (param $piece i32)
    (global.set $currentTurn (local.get $piece))
  )

  ;; Determine if it's a player's turn
  (func $isPlayersTurn (export "isPlayersTurn") (param $player i32) (result i32)
    (i32.gt_s
      (i32.and (local.get $player) (call $getTurnOwner))
      (i32.const 0)
    )
  )

  ;; Should this piece get crowned?
  ;; Black pieces are crowned in row 0 and white in row 7
  (func $shouldCrown (export "shouldCrown") (param $pieceY i32) (param $piece i32) (result i32)
    (i32.or
      (i32.and
        (i32.eq
          (local.get $pieceY)
          (i32.const 0))
        (call $isBlack (local.get $piece)))
      (i32.and
        (i32.eq
          (local.get $pieceY)
          (i32.const 7))
        (call $isWhite (local.get $piece)))
    )
  )

  ;; Crown a piece and invoke a host notifier
  (func $crownPiece (export "crownPiece") (param $x i32) (param $y i32)
    (local $piece i32)
    (local.set $piece (call $getPiece (local.get $x) (local.get $y)))
    (call $setPiece (local.get $x) (local.get $y)
      (call $withCrown (local.get $piece)))
    (call $notify_piececrowned (local.get $x) (local.get $y))
  )

  ;; Calculate distance
  (func $distance (param $x i32) (param $y i32) (result i32)
    (i32.sub (local.get $x) (local.get $y))
  )
)


