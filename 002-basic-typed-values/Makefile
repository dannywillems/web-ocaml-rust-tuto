all: build-ocaml build-rust bundle

ocaml-clean:
	cd ocaml && dune clean

build-rust:
	cd rust && wasm-pack build

build-ocaml:
	cd ocaml && dune build

bundle:
	webpack
