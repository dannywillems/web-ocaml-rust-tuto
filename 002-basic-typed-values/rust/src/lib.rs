use rand::Rng;
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn get_bool_true() -> bool {
    true
}

#[wasm_bindgen]
pub fn get_bool_false() -> bool {
    false
}

#[wasm_bindgen]
pub fn get_int64_zero() -> i64 {
    0
}

#[wasm_bindgen]
pub fn get_int64_random() -> i64 {
    let mut rng = rand::thread_rng();
    rng.gen::<i64>()
}
