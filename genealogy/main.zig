const std = @import("std");

const io = std.io;
const os = std.os;

const Person = struct {
    name: []u8,
    mother: *Person,
    father: *Person,
};

const Map = std.AutoHashMap([]u8, *Person);

const stdin = std.io.getStdIn().inStream();
const readUntil = stdin.readUntilDelimiterOrEof;

pub fn main() !void {
    const a = std.heap.page_allocator;
    const stdout = std.io.getStdOut().outStream();

    try stdout.print("Hello world!", .{});

    // Look up in hash table
    // If it doesn't exist, create new entry
    // Otherwise attach to existing entry

    var buf: [1024]u8 = undefined;
    var map = Map.init(a);

    // loop until EOF hit
    while (try readUntil(&buf, '\n')) |line| {
        try stdout.print("line {}\n", .{line});
    }
}
