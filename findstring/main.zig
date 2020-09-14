const std = @import("std");

const io = std.io;
const os = std.os;

pub fn main() !void {
    const a = std.heap.page_allocator;
    const stdout = std.io.getStdOut().outStream();
    const stream = &std.io.getStdIn().inStream();

    var buf: [1024]u8 = undefined;

    var args_it = std.process.args();

    _ = args_it.skip();

    var index: usize = 0;

    while (args_it.next(a)) |arg_or_err| : (index += 1) {
        const arg = try arg_or_err;
        try stdout.print("{}: {}\n", .{ index, arg });
    }

    var size = try stream.readAll(&buf);
    // loop until EOF hit
    while (size > 0) : (size = (try stream.readAll(&buf))) {
        var subSlice = buf[0..size];
        try stdout.print("Hello, {}!\n", .{subSlice});
    }
}
