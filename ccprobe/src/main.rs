extern "C" { fn probe_add(a: i32, b: i32) -> i32; }
fn main() { unsafe { println!("probe_add(2,40)={}", probe_add(2, 40)); } }
