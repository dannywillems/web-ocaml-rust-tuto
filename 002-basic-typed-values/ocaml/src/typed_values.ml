module JSHelpers = struct
  (* the returned type is bigint. Let's convert it to string and let's use
     Int64.of_string to get a correct OCaml type
  *)
  let to_int64 x =
    let open Js_of_ocaml in
    Int64.of_string (Js.to_string (Js.Unsafe.meth_call x "toString" [||]))
end

module Binding = struct
  let required_module =
    let open Js_of_ocaml in
    let m = Js.Unsafe.js_expr {|require ("rust-ocaml-basic-typed-values")|} in
    m

  let get_bool_true () =
    let open Js_of_ocaml in
    let x =
      Js.Unsafe.fun_call
        (Js.Unsafe.get required_module "get_bool_true")
        [| Js.Unsafe.inject () |]
    in
    Js.to_bool x

  let get_bool_false () =
    let open Js_of_ocaml in
    let x =
      Js.Unsafe.fun_call
        (Js.Unsafe.get required_module "get_bool_false")
        [| Js.Unsafe.inject () |]
    in
    Js.to_bool x

  let get_int64_zero () =
    let open Js_of_ocaml in
    let x =
      Js.Unsafe.fun_call
        (Js.Unsafe.get required_module "get_int64_zero")
        [| Js.Unsafe.inject () |]
    in
    JSHelpers.to_int64 x

  let get_int64_random () =
    let open Js_of_ocaml in
    let x =
      Js.Unsafe.fun_call
        (Js.Unsafe.get required_module "get_int64_random")
        [| Js.Unsafe.inject () |]
    in
    JSHelpers.to_int64 x
end

let () =
  Printf.printf
    "get_bool_true returns %s\n"
    (string_of_bool (Binding.get_bool_true ())) ;
  Printf.printf
    "get_bool_false returns %s\n"
    (string_of_bool (Binding.get_bool_false ())) ;
  Printf.printf
    "get_int64_random returns %s\n"
    (Int64.to_string (Binding.get_int64_random ())) ;
  Printf.printf
    "get_int64_zero returns %s\n"
    (Int64.to_string (Binding.get_int64_zero ()))
