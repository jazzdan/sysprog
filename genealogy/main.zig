const std = @import("std");

const io = std.io;
const os = std.os;

const Person = struct {
    name: []const u8,
    mother: *Person,
    father: *Person,
};

const Map = std.AutoHashMap([]const u8, *Person);

const stdin = std.io.getStdIn().inStream();
const readUntil = stdin.readUntilDelimiterOrEof;

fn handleField(a: *std.mem.Allocator, m: std.hash_map.AutoHashMap([]u8, *Person), fieldNum: u8, p: *Person, field: []const u8) void {
    if (fieldNum == 0) {
        m.put(field, p);
        p.name = field;
    } else if (fieldNum == 1) {
        // TODO(dmiller): insert in to hash map
        p.father = a.create(Person) catch @panic("Out of memory");
        p.father.* = Person{
            .name = field,
            .mother = undefined,
            .father = undefined,
        };
    } else if (fieldNum == 2) {
        // TODO(dmiller): insert in to hash map
        p.mother = a.create(Person) catch @panic("Out of memory");
        p.mother.* = Person{
            .name = field,
            .mother = undefined,
            .father = undefined,
        };
    }
}

pub fn main() !void {
    const a = std.heap.page_allocator;
    const stdout = std.io.getStdOut().outStream();

    // Look up in hash table
    // If it doesn't exist, create new entry
    // Otherwise attach to existing entry

    var buf: [1024]u8 = undefined;
    var map = Map.init(a);

    // loop until EOF hit
    while (try readUntil(&buf, '\n')) |line| {
        try stdout.print("line {}\n", .{line});
        var iterator = std.mem.split(line, ",");
        var p = a.create(Person) catch @panic("Out of memory");
        p.* = Person{
            .name = undefined,
            .mother = undefined,
            .father = undefined,
        };
        var fieldNum: u8 = 0;
        while (iterator.next()) |field| {
            try stdout.print("field {}\n", .{field});
            if (fieldNum == 0) {
                p.name = field;
            } else if (fieldNum == 1) {
                p.father = a.create(Person) catch @panic("Out of memory");
                p.father.* = Person{
                    .name = field,
                    .mother = undefined,
                    .father = undefined,
                };
            } else if (fieldNum == 2) {
                p.mother = a.create(Person) catch @panic("Out of memory");
                p.mother.* = Person{
                    .name = field,
                    .mother = undefined,
                    .father = undefined,
                };
            }
            fieldNum = fieldNum + 1;
        }
        var gop = try map.getOrPut(p.name);
        if (!gop.found_existing) {
            try map.put(p.name, p);
        }
    }
}
