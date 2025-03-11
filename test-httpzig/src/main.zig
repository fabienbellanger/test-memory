const std = @import("std");
const httpz = @import("httpz");

const Task = struct {
    id: u64,
    name: []const u8,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // More advance cases will use a custom "Handler" instead of "void".
    // The last parameter is our handler instance, since we have a "void"
    // handler, we passed a void ({}) value.
    var server = try httpz.Server(void).init(allocator, .{ .port = 3008 }, {});
    defer {
        // clean shutdown, finishes serving any live request
        server.stop();
        server.deinit();
    }

    var router = try server.router(.{});
    router.get("/", hello, .{});
    router.get("/json", json, .{});
    router.get("/api/user/:id", getUser, .{});

    // blocks
    std.debug.print("Listening on http://localhost:3008\n", .{});
    try server.listen();
}

fn hello(_: *httpz.Request, res: *httpz.Response) !void {
    res.status = 200;
    res.body = "Hello, World!";
}

fn getUser(req: *httpz.Request, res: *httpz.Response) !void {
    res.status = 200;
    try res.json(.{ .id = req.param("id").?, .name = "Teg" }, .{});
}

fn json(_: *httpz.Request, res: *httpz.Response) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const tasks = try allocator.alloc(Task, 500);
    defer allocator.free(tasks);

    for (tasks, 0..) |*task, i| {
        task.* = Task{ .id = i + 1, .name = try std.fmt.allocPrint(allocator, "Task number: {d}", .{i + 1}) };
    }

    res.status = 200;
    try res.json(tasks, .{});
}
