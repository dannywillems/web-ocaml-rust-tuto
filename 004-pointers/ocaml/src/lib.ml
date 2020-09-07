module Bindings = struct
  let required_module =
    let open Js_of_ocaml in
    let m =
      Js.Unsafe.js_expr
        {|require ("rust-ocaml-pointers")|}
    in
    m

  let get_new_pointer () =
    let open Js_of_ocaml in
    let open Js.Unsafe in
    let res =
      fun_call
        (get required_module "return_pointer")
        [| inject () |]
    in
    print_endline (string_of_float (Js.float_of_number res))
end

let () =
  Bindings.get_new_pointer ()
