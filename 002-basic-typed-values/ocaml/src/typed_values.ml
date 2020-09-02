module JSHelpers = struct
  let is_number x =
    let open Js_of_ocaml in
    Js.to_string (Js.typeof x) = "number"

  let is_bool x =
    let open Js_of_ocaml in
    Js.to_string (Js.typeof x) = "boolean"

  let is_bigint x =
    let open Js_of_ocaml in
    Js.to_string (Js.typeof x) = "bigint"

  (* the returned type is bigint. Let's convert it to string and let's use
     Int64.of_string to get a correct OCaml type
  *)
  let of_int64 x =
    let open Js_of_ocaml in
    assert (is_bigint x) ;
    Int64.of_string (Js.to_string (Js.Unsafe.meth_call x "toString" [||]))

  let of_uint16 x =
    let open Js_of_ocaml in
    assert (is_number x) ;
    Unsigned.UInt16.of_string
      (Js.to_string (Js.Unsafe.meth_call x "toString" [||]))

  let of_int32 x =
    let open Js_of_ocaml in
    assert (is_number x) ;
    Int32.of_string (Js.to_string (Js.Unsafe.meth_call x "toString" [||]))

  let of_uint32 x =
    let open Js_of_ocaml in
    assert (is_number x) ;
    Unsigned.UInt32.of_string
      (Js.to_string (Js.Unsafe.meth_call x "toString" [||]))

  let of_uint64 x =
    let open Js_of_ocaml in
    assert (is_bigint x) ;
    Unsigned.UInt64.of_string
      (Js.to_string (Js.Unsafe.meth_call x "toString" [||]))

  let of_bool x =
    let open Js_of_ocaml in
    assert (is_bool x) ;
    Js.to_bool x

  let of_u8 x =
    let open Js_of_ocaml in
    assert (is_number x) ;
    Bytes.of_string (string_of_int (int_of_float (Js.float_of_number x)))

  let of_usize x =
    let open Js_of_ocaml in
    assert (is_number x) ;
    Int64.of_string (Js.to_string (Js.Unsafe.meth_call x "toString" [||]))

  let of_int64_option x =
    let open Js_of_ocaml in
    (* assert (is_number x); *)
    let x = Js.Opt.to_option x in
    Option.bind x (fun x ->
        Some
          (Int64.of_string
             (Js.to_string (Js.Unsafe.meth_call x "toString" [||]))))
end

module Binding = struct
  open Js_of_ocaml

  let required_module =
    let m = Js.Unsafe.js_expr {|require ("rust-ocaml-basic-typed-values")|} in
    m

  let call_without_parameter name =
    Js.Unsafe.fun_call
      (Js.Unsafe.get required_module name)
      [| Js.Unsafe.inject () |]

  let get_bool_true () =
    let x = call_without_parameter "get_bool_true" in
    JSHelpers.of_bool x

  let get_bool_false () =
    let x = call_without_parameter "get_bool_false" in
    JSHelpers.of_bool x

  let get_int32_zero () =
    let x = call_without_parameter "get_int32_zero" in
    JSHelpers.of_int32 x

  let get_int32_random () =
    let x = call_without_parameter "get_int32_random" in
    JSHelpers.of_int32 x

  let get_uint16_zero () =
    let x = call_without_parameter "get_uint16_zero" in
    JSHelpers.of_uint16 x

  let get_uint16_random () =
    let x = call_without_parameter "get_uint16_random" in
    JSHelpers.of_uint16 x

  let get_uint32_zero () =
    let x = call_without_parameter "get_uint32_zero" in
    JSHelpers.of_uint32 x

  let get_uint32_random () =
    let x = call_without_parameter "get_uint32_random" in
    JSHelpers.of_uint32 x

  let get_int64_zero () =
    let x = call_without_parameter "get_int64_zero" in
    JSHelpers.of_int64 x

  let get_int64_random () =
    let x = call_without_parameter "get_int64_random" in
    JSHelpers.of_int64 x

  let get_option_int64_null () =
    let x = call_without_parameter "get_option_int64_null" in
    let x = JSHelpers.of_int64_option x in
    assert (Option.is_none x) ;
    x

  let get_option_int64_some () =
    let x = call_without_parameter "get_option_int64_some" in
    let x = JSHelpers.of_int64_option x in
    assert (Option.is_some x) ;
    x

  let get_uint64_random () =
    let x = call_without_parameter "get_uint64_random" in
    JSHelpers.of_uint64 x

  let get_uint64_max () =
    let x = call_without_parameter "get_uint64_max" in
    JSHelpers.of_uint64 x

  let get_u8_random () =
    let x = call_without_parameter "get_u8_random" in
    JSHelpers.of_u8 x

  let get_usize_random () =
    let x = call_without_parameter "get_usize_random" in
    JSHelpers.of_usize x

  let get_usize_min () =
    let x = call_without_parameter "get_usize_min" in
    let x = JSHelpers.of_usize x in
    assert (x = 0L) ;
    x

  let get_usize_max () =
    let x = call_without_parameter "get_usize_max" in
    let x = JSHelpers.of_usize x in
    (* usize with wasm32-unknown-unknown is coded on 32 bits *)
    assert (x = 4294967295L) ;
    x
end

let () =
  Printf.printf
    "get_bool_true returns %s\n"
    (string_of_bool (Binding.get_bool_true ())) ;
  Printf.printf
    "get_bool_false returns %s\n"
    (string_of_bool (Binding.get_bool_false ())) ;
  (* uint64 *)
  Printf.printf
    "get_uint64_random returns %s\n"
    (Unsigned.UInt64.to_string (Binding.get_uint64_random ())) ;
  Printf.printf
    "get_uint64_max returns %s\n"
    (Unsigned.UInt64.to_string (Binding.get_uint64_max ())) ;
  (* int64 *)
  Printf.printf
    "get_int64_random returns %s\n"
    (Int64.to_string (Binding.get_int64_random ())) ;
  Printf.printf
    "get_int64_zero returns %s\n"
    (Int64.to_string (Binding.get_int64_zero ())) ;
  (* usize *)
  Printf.printf
    "get_usize_random_returns %s\n"
    (Int64.to_string (Binding.get_usize_random ())) ;
  Printf.printf
    "get_usize_max returns %s\n"
    (Int64.to_string (Binding.get_usize_max ())) ;
  Printf.printf
    "get_usize_min returns %s\n"
    (Int64.to_string (Binding.get_usize_min ())) ;
  (* int32 *)
  Printf.printf
    "get_int32_random returns %s\n"
    (Int32.to_string (Binding.get_int32_random ())) ;
  Printf.printf
    "get_int32_zero returns %s\n"
    (Int32.to_string (Binding.get_int32_zero ())) ;
  (* int64 option *)
  Printf.printf
    "get_int64_option_some returns %s\n"
    (Int64.to_string (Option.get (Binding.get_option_int64_some ()))) ;
  (* int64 option *)
  ignore @@ Binding.get_option_int64_null () ;
  print_endline "get_int64_option_null did not fail\n" ;
  (* uint32 *)
  Printf.printf
    "get_uint32_random returns %s\n"
    (Unsigned.UInt32.to_string (Binding.get_uint32_random ())) ;
  Printf.printf
    "get_uint32_zero returns %s\n"
    (Unsigned.UInt32.to_string (Binding.get_uint32_zero ())) ;
  (* uint16 *)
  Printf.printf
    "get_uint16_random returns %s\n"
    (Unsigned.UInt16.to_string (Binding.get_uint16_random ())) ;
  Printf.printf
    "get_uint16_zero returns %s\n"
    (Unsigned.UInt16.to_string (Binding.get_uint16_zero ())) ;
  Printf.printf
    "get_uint16_zero returns %s\n"
    (Unsigned.UInt16.to_string (Binding.get_uint16_zero ())) ;
  (* u8 *)
  Printf.printf
    "get_u8_random returns %s\n"
    (Bytes.to_string (Binding.get_u8_random ()))
