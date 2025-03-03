# Test of memory

## Test chi

```bash
cd test-chi
go build -o test-chi && ./test-chi

drill --benchmark drill.yml --stats --quiet -o 10
oha -z 30s -c 200 http://localhost:3000/
```

## Test axum

```bash
cd test-axum
cargo run --release

drill --benchmark drill.yml --stats --quiet -o 10
oha -z 30s -c 200 http://localhost:3001/
```

## Test actix

```bash
cd test-actix
cargo run --release

drill --benchmark drill.yml --stats --quiet -o 10
oha -z 30s -c 200 http://localhost:3002/
```

## Test rocket

```bash
cd test-axum
cargo run --release

drill --benchmark drill.yml --stats --quiet -o 10
oha -z 30s -c 200 http://localhost:3003/
```

## Test zig zap

```bash
cd test-zap
zig build run

drill --benchmark drill.yml --stats --quiet -o 10
oha -z 30s -c 200 http://localhost:3004/
```

## Test salvo

```bash
cd test-salvo
cargo run --release

drill --benchmark drill.yml --stats --quiet -o 10
oha -z 30s -c 200 http://localhost:3005/
```

## Test viz

```bash
cd test-viz
cargo run --release

drill --benchmark drill.yml --stats --quiet -o 10
oha -z 30s -c 200 http://localhost:3006/
```

## Test ntex

```bash
cd test-ntex
cargo run --release

drill --benchmark drill.yml --stats --quiet -o 10
oha -z 30s -c 200 http://localhost:3007/
```
