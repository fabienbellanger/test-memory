const std = @import("std");
const zap = @import("zap");

fn on_request(r: zap.Request) void {
    r.sendBody("Hello, World!") catch return;
}

pub fn main() !void {
    var listener = zap.HttpListener.init(.{
        .port = 3004,
        .on_request = on_request,
        .log = false,
        .max_clients = 10_000_000,
    });
    try listener.listen();

    std.debug.print("Listening on 0.0.0.0:3004\n", .{});

    zap.start(.{
        .threads = 6,
        .workers = 1, // 1 worker enables sharing state between threads
    });
}
