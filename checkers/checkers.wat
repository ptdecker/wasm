;; Pure WASM Checkers Implementation
;;
;; Based on wasmcheckers/func_test.wat on p. 27 of Kevin Hoffman's "Programming WebAssembly
;; with Rust" with the following modificaitons:
;;
;; - Replaced deprecated `get_local` with local.get
;; - Replaced deprecated `get_global` with global.get
;; - Replace power of two multiplications with left bit shifts

(module
	(memory $men 1)

	;; Globals
	(global $BLACK i32 (i32.const 1))
	(global $WHITE i32 (i32.const 2))
	(global $CROWN i32 (i32.const 4))

	;; offsetForPosition = 4 * indexForPosition [4 * ((8 * x) + y)]
	(func $offsetForPosition (param $x i32) (param $y i32) (result i32)
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
  (func $isCrowned (param $piece i32) (result i32)
	  (i32.eq
		  (i32.and (local.get $piece) (global.get $CROWN))
			(global.get $CROWN)
	  )
	)
	
	;; Determine if a piece is white
  (func $isWhite (param $piece i32) (result i32)
	  (i32.eq
		  (i32.and (local.get $piece) (global.get $WHITE))
			(global.get $WHITE)
	  )
	)
	
	;; Determine if a piece is black
  (func $isBlack (param $piece i32) (result i32)
	  (i32.eq
		  (i32.and (local.get $piece) (global.get $BLACK))
			(global.get $BLACK)
	  )
	)

	;; Adds a crown to a given piece (no mutation)
	(func $withCrown (param $piece i32) (result i32)
		(i32.or (local.get $piece) (global.get $CROWN))
	)

	;; Removes a crown from a given piece (no mutation)
	(func $withoutCrown (param $piece i32) (result i32)
		(i32.and (local.get $piece) (i32.const 3))
	)
	
  (export "offsetForPosition" (func $offsetForPosition))
	(export "isCrowned" (func $isCrowned))
	(export "isWhite" (func $isWhite))
	(export "isBlack" (func $isBlack))
	(export "withCrown" (func $withCrown))
	(export "withoutCrown" (func $withoutCrown))
)

