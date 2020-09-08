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
    let _buffer = Bytes.make size_in_bytes '\000' in
    Js.Unsafe.fun_call (Js.Unsafe.get required_module "get_random_fr") [| Js.Unsafe.inject () |]
end

let () =
  Bindings.get_random_fr ()
