module JSBigInt = struct
  open Js_of_ocaml

  let of_int x =
    Js.Unsafe.fun_call (Js.Unsafe.js_expr "BigInt") [| Js.Unsafe.inject (Js.string (string_of_int x)) |]

  let of_uint64 x =
    Js.Unsafe.fun_call (Js.Unsafe.js_expr "BigInt") [| Js.Unsafe.inject (Js.string (Unsigned.UInt64.to_string x)) |]
end

module JSHelpers = struct
    open Js_of_ocaml

    let of_uint64 x =
    Unsigned.UInt64.of_string
      (Js.to_string (Js.Unsafe.meth_call x "toString" [||]))

    let to_uint64_js x =
      JSBigInt.of_uint64 x
end

module Bindings = struct
  open Js_of_ocaml

  let required_module =
    let m = Js.Unsafe.js_expr {|require ("rust-ocaml-passing-values-from-ocaml-to-rust")|} in
    m

  let add_u64 x y =
    let res = Js.Unsafe.fun_call
      (Js.Unsafe.get required_module "add_u64")
      [| Js.Unsafe.inject (JSHelpers.to_uint64_js x); Js.Unsafe.inject (JSHelpers.to_uint64_js y) |]
    in
    JSHelpers.of_uint64 res
end

let () =
  Printf.printf "Sum of 1 and 1 as uint64 is %s\n" (Unsigned.UInt64.(to_string (Bindings.add_u64 one one)));
  Printf.printf "Sum of 21 and 21 as uint64 is %s\n" (Unsigned.UInt64.(to_string (Bindings.add_u64 (of_string "21") (of_string "21"))))
