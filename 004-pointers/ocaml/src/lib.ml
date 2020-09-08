module Bindings = struct
  let required_module =
    let open Js_of_ocaml in
    let m =
      Js.Unsafe.js_expr
        {|require ("rust-ocaml-pointers")|}
    in
    m

  let size_in_bytes = 32

  let get_random_fr () =
    let open Js_of_ocaml in
    let open Js.Unsafe in
    let _buffer = Bytes.make size_in_bytes '\000' in
    fun_call (get required_module "rustc_bls12_381_fr_random") [| inject () |]
end

let () =
  Bindings.get_random_fr ()
