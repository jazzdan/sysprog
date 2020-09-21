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
            if (fieldNum == 1) {
                p.name = field;
            } else if (fieldNum == 2) {
                p.father = a.create(Person) catch @panic("Out of memory");
                p.father.* = Person{
                    .name = field,
                    .mother = undefined,
                    .father = undefined,
                };
            } else if (fieldNum == 3) {
                p.mother = a.create(Person) catch @panic("Out of memory");
                p.mother.* = Person{
                    .name = field,
                    .mother = undefined,
                    .father = undefined,
                };
            }
            fieldNum = fieldNum + 1;
        }
        try stdout.print("Putting {} in hashmap\n", .{p.name});
        var gop = try map.getOrPut(p.name);
        if (!gop.found_existing) {
            try map.put(p.name, p);
        } else {
            @panic("No duplicates allowed");
        }
    }

    var args_it = std.process.args();

    var target_person: []u8 = undefined;
    // skip program name
    _ = args_it.skip();
    // TODO(dmiller): this arg handling could probably be simplified
    // but for now just grab the first one
    // TODO(dmiller): error handling
    while (args_it.next(a)) |arg_or_err| {
        const arg = try arg_or_err;
        try stdout.print("target person is: {}\n", .{arg});
        target_person = arg;
        break;
    }

    var result = map.get(target_person);
    try stdout.print("result is: {}\n", .{result});
}
