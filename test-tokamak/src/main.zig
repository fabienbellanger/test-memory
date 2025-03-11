const std = @import("std");
const tk = @import("tokamak");

const Task = struct {
    id: u64,
    name: []const u8,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    std.debug.print("Listening on http://localhost:3009\n", .{});
    var server = try tk.Server.init(allocator, routes, .{ .listen = .{ .port = 3009 } });
    try server.start();
}

const routes: []const tk.Route = &.{
    .get("/", hello),
    .get("/json", json),
};

fn hello() ![]const u8 {
    return "Hello, World!";
}

fn json(allocator: std.mem.Allocator, res: *tk.Response) !void {
    const tasks = try allocator.alloc(Task, 500);
    defer allocator.free(tasks);

    for (tasks, 0..) |*task, i| {
        task.* = Task{ .id = i + 1, .name = try std.fmt.allocPrint(allocator, "Task number: {d}", .{i + 1}) };
    }

    try res.json(tasks, .{});
}
