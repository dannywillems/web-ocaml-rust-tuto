# web-ocaml-rust-tuto

List of tutorials/projects experiencing OCaml and Rust mixed code running
together in the browser.

Before starting, read the section about [setting up the environment](#setup-the-environment).

## Notes

- `wasm-pack build --target nodejs` will build a ES module than can be used in NodeJS.
Imagine you have a 
```rust
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn return_zero() -> u64 {
    0
}
```
built with `wasm-pack build --target nodejs`. You can after that use
```
node --experimental-modules --experimental-wasm-modules
> var t = require("./pkg/js_of_ruml.js")
> t.return_zero()
```

The default build target is `bundler` which requires a bundler (like webpack) afterwards.

- It looks like there are some issues related to `wasm-opt` (WASM optimizer)
  while building with `wasm-pack`. Adding these build options in the toml fix
  temporarily the issue
```
# https://github.com/rustwasm/wasm-pack/issues/886
[package.metadata.wasm-pack.profile.release]
wasm-opt = ["-O2", "--enable-mutable-globals"]
```

- 

### Rust

- [wasm-pack](https://github.com/rustwasm/wasm-pack): tools to get a workflow to build wasm code from Rust.
- [rustwasm](https://rustwasm.github.io/docs/wasm-bindgen/introduction.html): book about Rust and WASM
- [Awesome Rust/WASM](https://github.com/rustwasm/awesome-rust-and-webassembly): list of projects related to Rust/WASM interop

## Setup the environment

### Rust

Install wasm-pack
```
curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
```

### NodeJS

To build the Rust code and use it in Node, install node using nvm, and install
the latest Node version (`nvm install 12.18.3` followed by `nvm use 12.18.3`).

