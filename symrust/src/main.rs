fn main() {
    std::fs::write("real.txt", "x").unwrap();
    #[cfg(windows)]
    std::os::windows::fs::symlink_file("real.txt", "link.txt").expect("symlink_file failed");
    let m = std::fs::symlink_metadata("link.txt").unwrap();
    println!("RUST_IS_SYMLINK={}", m.file_type().is_symlink());
    let sz = std::fs::metadata("link.txt").unwrap().len();
    println!("RUST_LINK_TARGET_SIZE={}", sz); // 1 if real symlink to real.txt, not a stub
}
