# Conway's Game of Life Example from Rust and WebAssembly Book

This directory contains a working (as of 2024-04-19) commit of the Game of Life example contained
in the [Rust and WebAssembly](https://rustwasm.github.io/docs/book/introduction.html#rust--and-webassembly-)
book.

The tutorial does not run, and getting the canvas rendering version working had additional complications.
There are many open issues and pull requests in the [book's repository](https://github.com/rustwasm/book).
As of this writing, the repo seems to have no maintainers.

The tutorial leverages webpack and node for hosting. This adds additional complications.

I was finally able to get it working.

* The `build.sh` script (which must be `source`'d) will run the needed steps from the tutorial. If you
don't source it and instead try to run the commands as a just receipt directly, either webpack or npm
seems to get confused and puts things where it shouldn't. I don't know why.
* `assets` contains the tutorial HTML and JavaScript files along with some files to patch the webpack
template that the tutorial uses which is grossly out of date.
* To keep things clean, I just fully build the `www` directory from scratch applying the patches
as needed to get things going. The `www` directory is ignored in `.gitignore`
* You can use `just build` to build everything which simply sources the `build.sh` script.
* Once built, you can use `just run` to start the web server.
* You can then browse to http://localhost:8080/ to run it.
* I have not tested this on anything other than my Mac (M1 Pro with Sonoma)
* `just test` can be used to run the tests.

Version tags:
* [Commit 5252cec](https://github.com/ptdecker/wasm/commit/5252cec2a8f6cb1a8bb2cb2d46a0939372b6fbc1) - Tutorial 4.4
* [Commit 57dbc5b](https://github.com/ptdecker/wasm/commit/57dbc5ba341eaa479a14b314ee5b01f2b4f77601) - Tutorial 4.5
* [Commit 9fba0a9](https://github.com/ptdecker/wasm/commit/9fba0a9d27b94989ab3712721cb678a5b0f80974) - Tutorial 4.6
* [Commit 1fd37bb](https://github.com/ptdecker/wasm/commit/1fd37bbda8aae3cbd89ce15c14c3e98bda74c85d) - Tutorial 4.7
* [Commit 48841f4](https://github.com/ptdecker/wasm/commit/48841f43f9cadc364aee6b796b749cb31f3dc08b) - Tutorial 4.8