use std::ptr;
use wasm_bindgen::prelude::*;

use ff::{Field, PrimeField, PrimeFieldDecodingError, PrimeFieldRepr};
use pairing::bls12_381;
use pairing::bls12_381::Fr;

use rand::rngs::OsRng;

const LENGTH_FR_BYTES: usize = 32;
type c_uchar = u8;

pub fn read_fr(from: &[c_uchar; LENGTH_FR_BYTES]) -> Result<Fr, PrimeFieldDecodingError> {
    let mut f = <Fr as PrimeField>::Repr::default();
    f.read_le(&from[..]).unwrap();
    Fr::from_repr(f)
}

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

#[wasm_bindgen]
pub extern "C" fn rustc_bls12_381_fr_add(
    buffer: *mut [c_uchar; LENGTH_FR_BYTES],
    x: *const [c_uchar; LENGTH_FR_BYTES],
    y: *const [c_uchar; LENGTH_FR_BYTES],
) {
    let mut x = read_fr(unsafe { &*x }).unwrap();
    let y = read_fr(unsafe { &*y }).unwrap();
    x.add_assign(&y);
    write_fr(buffer, x);
}
