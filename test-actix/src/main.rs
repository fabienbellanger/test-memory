use actix_web::{get, App, HttpResponse, HttpServer, Responder};
use serde::Serialize;
#[derive(Serialize)]
struct Task {
    id: u64,
    name: String,
}

#[get("/")]
async fn hello() -> impl Responder {
    HttpResponse::Ok().body("Hello, world!")
}

#[get("/json")]
async fn json() -> impl Responder {
    let tasks = (0..500).into_iter().map(|i| Task {
        id: i + 1,
        name: format!("Task number: {}", i + 1),
    }).collect::<Vec<_>>();

    HttpResponse::Ok().json(tasks)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(hello)
            .service(json)
    })
    .bind(("127.0.0.1", 3002))?
    .run()
    .await
}