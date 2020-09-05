const std = @import("std");

const io = std.io;
const os = std.os;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const stdout = std.io.getStdOut().outStream();
    try stdout.print("Hello, {}!\n", .{"world"});

    const stream = &std.io.getStdIn().inStream();

    var repl_buf: [1024]u8 = undefined;

    while (try stream.readUntilDelimiterOrEof(&repl_buf, '\n')) |line| {
        if (line.len == 0) {
            break;
        }

        for (line) |c| {
            // TODO(dmiller): Maybe I can tell the string format to print this as a char instead of ASCII code point??
            try stdout.print("{}\n", .{c});
        }
    }
}
