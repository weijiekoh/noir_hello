fn main(x : Field) {
    let val = x as u32;
    assert((val < 6) | (val != 0));
}
