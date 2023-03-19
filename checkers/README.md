# Instructions

To complile the checkers pure WASM applicaiton:

```script
wat2wasm checkers.wat
```

To run tests, use python to load an http server:

```script
python3 -m http.server
```

Once the server is running, browse to:

[http://127.0.0.1:8000/func_test.html](http://127.0.0.1:8000/func_test.html)

