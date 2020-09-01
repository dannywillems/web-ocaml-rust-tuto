(* The module structure is not a requirement. It is only to split bindings with
   non-bindings routines
*)
module Binding = struct
  let print_hello_world () =
    (* This is the equivalent of the following JavaScript code:

       var f = require("rust-ocaml-hello-world");
       f.print_hello_world();
    *)
    let open Js_of_ocaml in
    let m = Js.Unsafe.js_expr {|require ("rust-ocaml-hello-world")|} in
    ignore
    @@ Js.Unsafe.fun_call
         (Js.Unsafe.get m "print_hello_world")
         [| Js.Unsafe.inject () |]
end

let () =
  (* We call first the Rust routine *)
  Binding.print_hello_world () ;
  (* Jsoo transformed this in a console.log *)
  print_string "Hello, World from OCaml"
