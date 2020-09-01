# 001 - Basic mixed Hello, World in the console

In this first tutorial, we are going to export a function on the Rust side
printing in the console `Hello, World from Rust`. On the Caml side, this
function is going to be called and a second message `Hello, World from OCaml`
will be printed in the console.

No type mixing is required, that's then the easiest way to get first our hands
in the process.

The general idea is to use wasm-bindgen and use wasm-pack to build an ES module
exporting the functions we want to get access to in OCaml.
On the Caml side, js_of_ocaml is used to compile Caml programs to JavaScript programs.
The main entry point is the JavaScript file js_of_ocaml produced. The
JavaScript produced by jsoo is not an ES module.

## Step by step explanation

We will go in a step by step explanation on how to build a Caml/Rust mixed webapp.
In this first tutorial, we are going to explain each step. In future tutorials,
these steps are gonna be skipped.
During the entire build process, we keep in mind that the Rust code can be
shipped by a third-party, and we do not necessarily compile ourselves the code.
It can already be a package available in a NPM registry.

First, we are going to look at the Rust code and generate an ES module which is
going to be used by the OCaml code. We will not focus on the underlying libraries details.

### Rust

The code is available in the subdirectory `rust/`.
The Rust part is pretty straightforward and copy an example from the wasm-bindgen documentation.

```rust
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
extern "C" {
    #[wasm_bindgen(js_namespace = console)]
    fn log(s: &str);
}

#[wasm_bindgen]
pub fn print_hello_world() {
    log("Hello, World from Rust");
}
```

This code will export a function `print_hello_world` which does not expect any
argument and returns nothing. The body is only calling `console.log` and print a
value. Value conversions between JS and Rust are performed by wasm-bindgen,
allowing us to use directly a Rust str value.
The tool `wasm-pack` is quite powerful and it is the one we are going to use to
build the ES module. The default target option is fine for us.

```shell
wasm-pack build
```

We have now a ES module, with the `package.json` ready, in the `pkg` directory. The npm package is called `rust-ocaml-hello-world`.
On the OCaml side, we want to get something compiling to:
```javascript
var f = require("rust-ocaml-hello-world")
f.print_hello_world();
```

To give access to the `rust-ocaml-hello-world` local package to other packages, use:
```
npm link
```
in the `pkg` directory.

It will allow us to use the package in our OCaml codebase as if it was a package
available in a NPM registry. Using this allows us to be more general in the
process.

### OCaml

Let's move now into the `ocaml` directory.
Let's first setup the switch we are going to work in:

```shell
opam switch create ./ 4.09.1
eval $(opam config env)
opam install js_of_ocaml.3.7.0 js_of_ocaml-compiler.3.7.0 js_of_ocaml-ppx.3.7.0
# Optional, dev tools
opam install merlin ocamlformat.0.15.0
```

On the OCaml side, the code is also straightforward (even if a bit ugly because
of jsoo primitives not being ES module friendly).

```ocaml
(* The module structure is not a requirement. It is only to split bindings with
   non-bindings routines
*)
module Binding = struct
    let print_hello_world () =
      (* This is the equivalent of the following JavaScript code:

         var f = require("rust-ocaml-hello-world");
         f.print_hello_world();
      *)
      let open Js_of_ocaml in
      let m = Js.Unsafe.js_expr {|require ("rust-ocaml-hello-world")|} in
      ignore @@ Js.Unsafe.fun_call (Js.Unsafe.get m "print_hello_world") [|Js.Unsafe.inject ()|]
end

let () =
  (* We call first the Rust routine *)
  Binding.print_hello_world ();
  (* Jsoo transformed this in a console.log *)
  print_string "Hello, World from OCaml"
```

Let's compile to a JS file. You can have a look at the `dune` file.
```
# In the ocaml directory.
dune build
```

A JavaScript file has been produced in `_build/default/src/` called
`PrintHello.js`. This is going to be our main JavaScript program that's gonna
run in the browser.

### Bundle up

It is now time to bundle up both JavaScript codes and run the final code in a
browser.
The compilation steps are summarized in a Makefile.

In the root directory, we will create a `package.json` file:

```json
{
    "dependencies": {"rust-ocaml-hello-world": "0.1.0"},
    "scripts": {
        "build": "make all",
        "serve": "webpack-dev-server"
    },
    "devDependencies": {
        "html-webpack-plugin": "^3.2.0",
        "webpack": "^4.29.4",
        "webpack-cli": "^3.1.1",
        "webpack-dev-server": "^3.1.0"
    }
}
```

The NPM package `rust-ocaml-hello-world` created previously by wasm-bindgen is
one of our dependencies. We need to run `npm link rust-ocaml-hello-world` before
running `npm install -d`.
webpack is used to bundle the code, and `webpack-dev-server` with
`html-webpack-plugin` are used provide a simple HTML page serving the resulting
bundled JavaScript. It can always be replaced by a `script` tag.

On the webpack config file, we have:
```javascript
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const webpack = require('webpack');

module.exports = {
    // Required!!!! See https://github.com/webpack/webpack/issues/6615#issuecomment-668177931
    entry: './bootstrap.js',
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: 'bundle.js'
    },
    plugins: [
        new HtmlWebpackPlugin(),
    ],
    node: {
        fs: "empty",
    },
    mode: "production"
};
```

The bootstrap.js file is simply importing the JavaScript program generated by
jsoo. It is required because wasm code must be loaded first.
> This step should be performed on the Caml side, but I haven't found a way yet.

The line
```
fs: "empty"
```
is to bypass a resolving error got during bundle

We are now ready to bundle:
```
# « make bundle » or « npm run serve » can also be used
webpack
```

Go on http://localhost:8080 and open the console. You should see `Hello, World
from Rust` followed by `Hello, World from OCaml`.

When building, be sure you are in the correct opam switch, otherwise, OCaml
compilation is not going to work.
