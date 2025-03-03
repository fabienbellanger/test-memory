use salvo::prelude::*;

#[handler]
async fn hello() -> &'static str {
    "Hello, World!"
}

#[tokio::main]
async fn main() {
    let router = Router::new().get(hello);
    let acceptor = TcpListener::new("127.0.0.1:3005").bind().await;
    Server::new(acceptor).serve(router).await;
}