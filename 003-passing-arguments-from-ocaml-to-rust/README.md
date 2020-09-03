# 003 - Passing OCaml values to Rust

This part will be focused on passing OCaml values to Rust.

Reminder for the basic types:

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

[jsoo-lib](https://github.com/dannywillems/jsoo-lib) is used to replace JSHelpers. It is not a requirement.

It is quite straightforward how we must pass values. We have to convert in the JavaScript type Rust is waiting for.
Here an example of `val add_u64: Unsigned.UInt64.t -> Unsigned.UInt64.t -> Unsigned.UInt64.t`:

```ocaml
  let add_u64 x y =
    let open Js.Unsafe in
    let res =
      fun_call
        (get required_module "add_u64")
        [| inject BigInt.(to_any_js (of_uint64 x));
           inject BigInt.(to_any_js (of_uint64 y))
        |]
    in
    BigInt.(to_uint64 (of_js res))
```
`BigInt` is a high level Caml module provided by `Jsoo_lib` abstracting the `BigInt` class using js_of_ocaml.

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
