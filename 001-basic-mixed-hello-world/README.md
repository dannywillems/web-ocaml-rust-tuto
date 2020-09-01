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
The main entry point is the JavaScript file the js_of_ocaml produced. The
JavaScript produced by jsoo is not an ES module.


## Try

```
npm install
cd ocaml
opam switch ./ 4.09.1
eval $(opam config env)
opam install js_of_ocaml.3.7.0 js_of_ocaml-compiler.3.7.0 js_of_ocaml-ppx.3.7.0
npm run build
npm run serve
```

Go on http://localhost:8080 and open the console. You should see `Hello, World from Rust` followed by `Hello, World from OCaml`.
