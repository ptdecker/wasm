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
	(memory $men 1)

	;; Globals
	(global $BLACK (export "BLACK") i32 (i32.const 1))
	(global $WHITE (export "WHITE") i32 (i32.const 2))
	(global $CROWN (export "CROWN") i32 (i32.const 4))

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
)

