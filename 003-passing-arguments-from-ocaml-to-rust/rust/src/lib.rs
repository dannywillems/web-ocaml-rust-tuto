use wasm_bindgen::prelude::*;

#[wasm_bindgen]
extern "C" {
    #[wasm_bindgen(js_namespace = console)]
    fn log(s: &str);
}

#[wasm_bindgen]
pub fn add_u64(x: u64, y: u64) -> u64 {
    let s = x + y;
    log(&*format!("{} + {} = {}", x, y, s));
    s
}

#[wasm_bindgen]
pub fn add_u32(x: u32, y: u32) -> u32 {
    let s = x + y;
    log(&*format!("{} + {} = {}", x, y, s));
    s
}
