const std = @import("std");

const io = std.io;
const os = std.os;

pub fn main() !void {
    const a = std.heap.page_allocator;
    const stdout = std.io.getStdOut().outStream();
    const stream = &std.io.getStdIn().inStream();

    var buf: [1024]u8 = undefined;
    const Map = std.AutoHashMap(u8, u64);
    var map = Map.init(a);

    while (try stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (line.len == 0) {
            break;
        }

        for (line) |c| {
            var entry = map.getOrPut(c);
            entry = entry + 1;
            // TODO store back in map
        }
    }
}
