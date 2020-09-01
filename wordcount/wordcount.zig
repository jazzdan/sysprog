const std = @import("std");

const stdin = std.io.getStdIn().inStream();
const readUntil = stdin.readUntilDelimiterOrEof;
const space: u8 = 32;

pub fn main() !void {
    // TODO: what if this is really really big? How can you be efficient?
    var buf: [1000]u8 = undefined;
    var count: u8 = 0;
    while (try readUntil(&buf, ' ')) |word| {
        std.debug.print("Word: {}\n", .{word});
        count = count + 1;
    }

    std.debug.print("Word count: {}\n", .{count});
}
