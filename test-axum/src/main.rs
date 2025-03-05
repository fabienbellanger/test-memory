use axum::{routing::get, Json};
use serde::Serialize;

#[derive(Serialize)]
struct Task {
    id: u64,
    name: String,
}

#[tokio::main]
async fn main() {
    let app = axum::Router::new()
        .route("/", get(root))
        .route("/json", get(json));

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3001").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}

// basic handler that responds with a static string
async fn root() -> &'static str {
    "Hello, World!"
}

async fn json() -> Json<Vec<Task>> {
    let tasks = (0..500).into_iter().map(|i| Task {
        id: i + 1,
        name: format!("Task number: {}", i + 1),
    }).collect::<Vec<_>>();

    Json(tasks)
}
