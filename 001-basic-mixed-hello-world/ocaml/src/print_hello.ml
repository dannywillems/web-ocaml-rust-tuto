module Binding = struct
    let print_hello_world () =
      let open Js_of_ocaml in
      let m = Js.Unsafe.js_expr {|require ("./index.js")|} in
      ignore @@ Js.Unsafe.fun_call (Js.Unsafe.get m "print_hello_world") [|Js.Unsafe.inject ()|]
end

let () =
  Binding.print_hello_world ();
  print_string "Hello, World from OCaml"
