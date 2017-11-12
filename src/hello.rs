use std::io;

use futures::future;
use tokio_minihttp::{Request, Response};
use tokio_service::Service;

pub struct Hello;

impl Service for Hello {
    type Request = Request;
    type Response = Response;
    type Error = io::Error;
    type Future = future::Ok<Response, io::Error>;

    fn call(&self, _request: Request) -> Self::Future {
        let mut resp = Response::new();
        resp.body("200");
        future::ok(resp)
    }
}
