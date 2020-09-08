use std::ptr;
use wasm_bindgen::prelude::*;

use ff::{Field, PrimeField, PrimeFieldRepr};
use pairing::bls12_381;
use pairing::bls12_381::Fr;

use rand::rngs::OsRng;

const LENGTH_FR_BYTES: usize = 32;
type c_uchar = u8;

pub fn write_fr(buffer: *mut [c_uchar; LENGTH_FR_BYTES], element: Fr) {
    let buffer = unsafe { &mut *buffer };
    element.into_repr().write_le(&mut buffer[..]).unwrap();
}

#[wasm_bindgen]
pub fn return_pointer() -> *mut u8 {
    ptr::null_mut()
}

#[wasm_bindgen]
pub fn take_pointer_by_value(x: *mut u8) {}

#[wasm_bindgen]
pub fn rustc_bls12_381_fr_zero(buffer: *mut [c_uchar; LENGTH_FR_BYTES]) {
    let zero = bls12_381::Fr::zero();
    write_fr(buffer, zero)
}

#[wasm_bindgen]
pub fn rustc_bls12_381_fr_one(buffer: *mut [c_uchar; LENGTH_FR_BYTES]) {
    let one = bls12_381::Fr::one();
    write_fr(buffer, one)
}

#[wasm_bindgen]
pub fn rustc_bls12_381_fr_random(buffer: *mut [c_uchar; LENGTH_FR_BYTES]) {
    let random_x = Fr::random(&mut OsRng);
    write_fr(buffer, random_x)
}
