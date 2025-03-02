use axum::routing::get;

#[tokio::main]
async fn main() {
    let app = axum::Router::new()
        .route("/", get(root));

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3001").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}

// basic handler that responds with a static string
async fn root() -> &'static str {
    "Hello, World!"
}
