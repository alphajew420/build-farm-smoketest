fn main() {
    cc::Build::new().file("foo.c").compile("foo");
    println!("cargo:rerun-if-changed=foo.c");
}
