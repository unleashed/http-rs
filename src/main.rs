#![feature(alloc_system)]
extern crate alloc_system;

extern crate futures;
extern crate tokio_minihttp;
extern crate tokio_proto;
extern crate tokio_service;
extern crate num_cpus;

use tokio_minihttp::Http;
use tokio_proto::TcpServer;

mod hello;

#[inline(always)]
fn num_threads() -> usize {
    num_cpus::get()
}

fn main() {
    let addr = "0.0.0.0:7878".parse().unwrap();
    let threads = num_threads();
    println!("Running on {} threads", threads);
    let mut server = TcpServer::new(Http, addr);
    server.threads(threads);
    server.serve(move || {
        Ok(hello::Hello)
    });
}
