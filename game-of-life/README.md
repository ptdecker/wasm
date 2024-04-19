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

