module Bindings = struct
  open Js_of_ocaml
  open Jsoo_lib

  let required_module =
    let m =
      Js.Unsafe.js_expr
        {|require ("rust-ocaml-passing-values-from-ocaml-to-rust")|}
    in
    m

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

  let add_u32 x y =
    let open Js.Unsafe in
    let res =
      fun_call
        (get required_module "add_u32")
        [| inject Number.(to_any_js (of_uint32 x));
           inject Number.(to_any_js (of_uint32 y))
        |]
    in
    Number.(to_uint32 (of_js res))
end

let () =
  Printf.printf
    "Sum of 1 and 1 as uint64 is %s\n"
    Unsigned.UInt64.(to_string (Bindings.add_u64 one one)) ;
  Printf.printf
    "Sum of 21 and 21 as uint64 is %s\n"
    Unsigned.UInt64.(
      to_string (Bindings.add_u64 (of_string "21") (of_string "21"))) ;

  Printf.printf
    "Sum of 1 and 1 as uint32 is %s\n"
    Unsigned.UInt32.(to_string (Bindings.add_u32 one one)) ;
  Printf.printf
    "Sum of 21 and 21 as uint32 is %s\n"
    Unsigned.UInt32.(
      to_string (Bindings.add_u32 (of_string "21") (of_string "21")))
