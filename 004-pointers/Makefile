all: build-ocaml build-rust bundle

setup-ocaml:
	cd ocaml
	opam switch create ./ 4.09.1 -y
	eval $(opam config env)
	opam install js_of_ocaml.3.7.0 js_of_ocaml-ppx.3.7.0 js_of_ocaml-compiler.3.7.0 -y
	opam pin add integers-stubs-js https://gitlab.com/dannywillems/ocaml-integers-stubs.js

ocaml-clean:
	cd ocaml && eval $(opam config env) && dune clean

build-rust:
	cd rust && wasm-pack build
# require to get access to the memory in JavaScript
	echo "\nexport { wasm };" >> rust/pkg/rust_ocaml_pointers.js

build-ocaml:
	cd ocaml && eval $(opam config env) && dune build

bundle:
	webpack
