module Bindings = struct
  let size_in_bytes = 32

  let rustc_bls12_381_fr_random required_module () =
    let open Js_of_ocaml in
    let open Js.Unsafe in
    ignore @@ fun_call (get required_module "rustc_bls12_381_fr_random") [| inject () |];
    let memory = Jsoo_lib_rust_wasm.Memory.get_buffer required_module in
    let res = Jsoo_lib_rust_wasm.Memory.Buffer.slice memory 0 32 in
    Jsoo_lib_rust_wasm.Memory.Buffer.to_bytes res

  let rustc_bls12_381_fr_one required_module () =
    let open Js_of_ocaml in
    let open Js.Unsafe in
    ignore @@ fun_call (get required_module "rustc_bls12_381_fr_one") [| inject () |];
    let memory = Jsoo_lib_rust_wasm.Memory.get_buffer required_module in
    let res = Jsoo_lib_rust_wasm.Memory.Buffer.slice memory 0 32 in
    Jsoo_lib_rust_wasm.Memory.Buffer.to_bytes res

  let rustc_bls12_381_fr_zero required_module () =
    let open Js_of_ocaml in
    let open Js.Unsafe in
    ignore @@ fun_call (get required_module "rustc_bls12_381_fr_zero") [| inject () |];
    let memory = Jsoo_lib_rust_wasm.Memory.get_buffer required_module in
    let res = Jsoo_lib_rust_wasm.Memory.Buffer.slice memory 0 32 in
    Jsoo_lib_rust_wasm.Memory.Buffer.to_bytes res
end

let () =
  let open Js_of_ocaml.Js in
  let open Js_of_ocaml in
  let p : (Jsoo_lib.ESModule.t, Unsafe.any) Jsoo_lib.Promise.t = Jsoo_lib.Promise.of_any_js (Unsafe.js_expr {| import ("rust-ocaml-pointers") |}) in
  let on_resolved m =
    Firebug.console##log m;
    let random = Bindings.rustc_bls12_381_fr_random m () in
    print_endline @@ String.concat " " (List.map (fun x -> string_of_int (int_of_char x)) (List.of_seq (Bytes.to_seq random)))
  in
  Jsoo_lib.Promise.then_bind ~on_resolved p
