use rand::Rng;
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
extern "C" {
    #[wasm_bindgen(js_namespace = console)]
    fn log(s: &str);
}

#[wasm_bindgen]
pub fn get_bool_true() -> bool {
    true
}

#[wasm_bindgen]
pub fn get_bool_false() -> bool {
    false
}

#[wasm_bindgen]
pub fn get_uint32_zero() -> u32 {
    0
}

#[wasm_bindgen]
pub fn get_uint16_random() -> u16 {
    let mut rng = rand::thread_rng();
    rng.gen::<u16>()
}

#[wasm_bindgen]
pub fn get_uint16_zero() -> u16 {
    0
}

#[wasm_bindgen]
pub fn get_uint32_random() -> u32 {
    let mut rng = rand::thread_rng();
    rng.gen::<u32>()
}

#[wasm_bindgen]
pub fn get_int32_zero() -> i32 {
    0
}

#[wasm_bindgen]
pub fn get_int32_random() -> i32 {
    let mut rng = rand::thread_rng();
    rng.gen::<i32>()
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

#[wasm_bindgen]
pub fn get_uint64_random() -> u64 {
    let mut rng = rand::thread_rng();
    rng.gen::<u64>()
}

#[wasm_bindgen]
pub fn get_uint64_max() -> u64 {
    std::u64::MAX
}

#[wasm_bindgen]
pub fn get_u8_random() -> u8 {
    let mut rng = rand::thread_rng();
    let x = rng.gen::<u8>();
    x
}

#[wasm_bindgen]
pub fn get_usize_random() -> usize {
    let mut rng = rand::thread_rng();
    let x = rng.gen::<usize>();
    x
}

#[wasm_bindgen]
pub fn get_usize_min() -> usize {
    std::usize::MIN
}

#[wasm_bindgen]
pub fn get_usize_max() -> usize {
    // !! usize is on 32 bits when compiled with wasm32-unknown-unknown
    // wasm is only specified for 32 bits.
    std::usize::MAX
}

#[wasm_bindgen]
pub fn get_option_int64_null() -> Option<i64> {
    // !! usize is on 32 bits when compiled with wasm32-unknown-unknown
    // wasm is only specified for 32 bits.
    None
}

#[wasm_bindgen]
pub fn get_option_int64_some() -> Option<i64> {
    // !! usize is on 32 bits when compiled with wasm32-unknown-unknown
    // wasm is only specified for 32 bits.
    Some(42)
}
