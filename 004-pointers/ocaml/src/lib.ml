module Bindings = struct
  let size_in_bytes = 32

  let rustc_bls12_381_fr_random required_module () =
    let open Js_of_ocaml in
    let open Js.Unsafe in
    ignore
    @@ fun_call (get required_module "rustc_bls12_381_fr_random") [| inject 0 |] ;
    let memory = Jsoo_lib_rust_wasm.Memory.get_buffer required_module in
    let res = Jsoo_lib_rust_wasm.Memory.Buffer.slice memory 0 32 in
    Jsoo_lib_rust_wasm.Memory.Buffer.to_bytes res

  let rustc_bls12_381_fr_one required_module () =
    let open Js_of_ocaml in
    let open Js.Unsafe in
    ignore
    @@ fun_call
         (get required_module "rustc_bls12_381_fr_one")
         [| Js.Unsafe.inject 0 |] ;
    let memory = Jsoo_lib_rust_wasm.Memory.get_buffer required_module in
    let res = Jsoo_lib_rust_wasm.Memory.Buffer.slice memory 0 32 in
    Jsoo_lib_rust_wasm.Memory.Buffer.to_bytes res

  let rustc_bls12_381_fr_zero required_module () =
    let open Js_of_ocaml in
    let open Js.Unsafe in
    ignore
    @@ fun_call (get required_module "rustc_bls12_381_fr_zero") [| inject () |] ;
    (* The value is gonna be in the first 32 bytes of the buffer *)
    let memory = Jsoo_lib_rust_wasm.Memory.get_buffer required_module in
    let res = Jsoo_lib_rust_wasm.Memory.Buffer.slice memory 0 32 in
    Jsoo_lib_rust_wasm.Memory.Buffer.to_bytes res

  let rustc_bls12_381_fr_add required_module a b =
    let open Js_of_ocaml in
    let open Js.Unsafe in
    Jsoo_lib_rust_wasm.Memory.copy_in_buffer required_module a 0 32 32 ;
    Jsoo_lib_rust_wasm.Memory.copy_in_buffer required_module b 0 64 32 ;
    ignore
    @@ fun_call
         (get required_module "rustc_bls12_381_fr_add")
         [| inject 0; inject 32; inject 64 |] ;
    (* The value is gonna be in the first 32 bytes of the buffer *)
    let memory = Jsoo_lib_rust_wasm.Memory.get_buffer required_module in
    let res = Jsoo_lib_rust_wasm.Memory.Buffer.slice memory 0 32 in
    Jsoo_lib_rust_wasm.Memory.Buffer.to_bytes res
end

let print_fr_bytes_in_console a =
  print_endline
  @@ String.concat
       " "
       (List.map
          (fun x -> string_of_int (int_of_char x))
          (List.of_seq (Bytes.to_seq a)))

let bytes_to_zarith b = Z.to_string (Z.of_bits (Bytes.to_string b))

let () =
  let open Js_of_ocaml.Js in
  let open Js_of_ocaml in
  let p : (Jsoo_lib.ESModule.t, Unsafe.any) Jsoo_lib.Promise.t =
    Jsoo_lib.Promise.of_any_js
      (Unsafe.js_expr {| import ("rust-ocaml-pointers") |})
  in
  let on_resolved m =
    let a = Bindings.rustc_bls12_381_fr_random m () in
    let b = Bindings.rustc_bls12_381_fr_random m () in
    Firebug.console##log
      Jsoo_lib_rust_wasm.Memory.(Buffer.to_any_js (get_buffer m)) ;
    Firebug.console##log (bytes_to_zarith a) ;
    Firebug.console##log (bytes_to_zarith b) ;
    print_fr_bytes_in_console a ;
    print_fr_bytes_in_console b ;
    let sum = Bindings.rustc_bls12_381_fr_add m a b in
    Firebug.console##log
      Jsoo_lib_rust_wasm.Memory.(Buffer.to_any_js (get_buffer m)) ;
    Firebug.console##log (bytes_to_zarith sum) ;
    print_fr_bytes_in_console sum
  in
  Jsoo_lib.Promise.then_bind ~on_resolved p
