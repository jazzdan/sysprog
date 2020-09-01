const std = @import("std");

const stdin = std.io.getStdIn().inStream();
const readUntil = stdin.readUntilDelimiterOrEof;
const space: u8 = 32;

pub fn main() void {
    // TODO: what if this is really really big? How can you be efficient?
    var buf: [1000]u8 = undefined;
    const foo = readUntil(&buf, '\n');
    std.debug.print("{}\n", .{foo});
    var count: u8 = 0;
    for (buf) |character| {
        if (character == space) {
            count = count + 1;
        }
    }

    if (foo.length > 0 and count > 0) {
        count = count + 1;
    }

    std.debug.print("Word count: {}\n", .{count});
}
