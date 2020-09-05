const std = @import("std");

const io = std.io;
const os = std.os;

pub fn main() !void {
    const a = std.heap.page_allocator;
    const map = std.AutoHashMap(u8, u64);
    const stdout = std.io.getStdOut().outStream();
    const stream = &std.io.getStdIn().inStream();

    var buf: [1024]u8 = undefined;

    while (try stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (line.len == 0) {
            break;
        }

        for (line) |c| {
            var entry = map.getOrPut(c);
        }
    }
}
