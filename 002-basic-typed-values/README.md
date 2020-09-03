# 002 - Basic typed values

This part will be focused on passing Rust values to OCaml.

## About randomisation

Randomisation on the Rust side is also tested.
For the current version of rand and rand_core, getrandom is used. The documentation says

>  WASM: calls window.crypto.getRandomValues in browsers, and in Node.js
>  require("crypto").randomBytes


| Rust       | JavaScript       | OCaml     | Notes                                                                   |
|------------|------------------|-----------|-------------------------------------------------------------------------|
| u16        | Number           | UInt16    | Use string representation to convert from JavaScript to OCaml           |
| u32        | Number           | UInt32    | Use string representation to convert from JavaScript to OCaml           |
| u64        | BigInt           | UInt64    | Use string representation to convert from JavaScript to OCaml           |
| i32        | Number           | Int32     | Use string representation to convert from JavaScript to OCaml           |
| i64        | BigInt           | Int64     | Use string representation to convert from JavaScript to OCaml           |
| bool       | bool             | bool      | Use simply Js.to_bool                                                   |
| usize      | Number           | UInt32    | wasm is only specified on 32 bits                                       |
| u8         | Number           | Bytes     | `Bytes.of_string (string_of_int (int_of_float (Js.float_of_number x)))` |
| Option<'a> | null or 'a in Js | 'a option | Depends on 'a. Use Js.Opt.to_option                                     |
|------------|------------------|-----------|-------------------------------------------------------------------------|

### Unsupported types

- `c_uchar`, `size_t`: provided by libc, it is not available for the target
  `wasm32-unknown-unknown`, the one we use for the bindings in these tutorials.
  However, it is available for the emscripten target (`wasm32-unknown-emscripten`)

## Build

Same process than explained in the first tutorial.

```
# Build Rust and link NPM package
make build-rust
cd rust/pkg
npm link
cd ../../
npm link rust-ocaml-basic-typed-values

# Setup OCaml infrastructure
make setup-ocaml
make build-ocaml

# bundle
make webpack

# Serve
npm run serve
```
