// Required!!!! See https://github.com/webpack/webpack/issues/6615#issuecomment-668177931

import("rust-ocaml-pointers").then((wasm) => {
    console.log(wasm);
    console.log("Hello, world");
}
);
    // console.log("hello, world"));
// import wasm from "rust-ocaml-pointers";

// async function run() {
//     let wasm = await init();
//     window.wasm = wasm;
//     console.log(wasm);
// }
// run();
