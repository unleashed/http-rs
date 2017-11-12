FROM fedora:26

ADD target/x86_64-unknown-linux-musl/release/http-rs /
CMD ["/http-rs"]
