const std = @import("std");

const io = std.io;
const os = std.os;
const sort = std.sort;

const Map = std.AutoHashMap(u8, u64);

fn entryLessThan(context: void, lhs: Map.Entry, rhs: Map.Entry) bool {
    return lhs.value > rhs.value;
}

pub fn main() !void {
    const a = std.heap.page_allocator;
    const stdout = std.io.getStdOut().outStream();
    const stream = &std.io.getStdIn().inStream();

    // TODO what happens if I read in a really big file
    var buf: [1024]u8 = undefined;
    var map = Map.init(a);

    var size = try stream.readAll(&buf);
    // loop until EOF hit
    // read(numBytes, &buf)
    while (size > 0) : (size = (try stream.readAll(&buf))) {
        var subSlice = buf[0..size];
        for (subSlice) |c| {
            var gop = try map.getOrPut(c);
            var count: u64 = 1;
            if (gop.found_existing) {
                count = gop.entry.value + 1;
            }
            try map.put(c, count);
        }
    }

    // Entry<int, int>
    var items = map.items();

    sort.sort(Map.Entry, items, {}, entryLessThan);

    for (items) |entry| {
        // TODO(dmiller): I wonder if there's a way to handle unicode
        try stdout.print("'{c}' {d}\n", .{ entry.key, entry.value });
    }
}
