const std = @import("std");

const io = std.io;
const os = std.os;
const Blake3 = std.crypto.hash.Blake3;

const Person = struct {
    name: []const u8,
    mother: *Person,
    father: *Person,
};

// TODO(dmiller): does this need to be a pointer to a Person?
const HashToPerson = std.StringHashMap(*Person);

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
    var map = HashToPerson.init(a);

    // loop until EOF hit
    while (try readUntil(&buf, '\n')) |line| {
        try stdout.print("line {}\n", .{line});
        var iterator = std.mem.split(line, ",");
        var p: *Person = a.create(Person) catch @panic("Out of memory");
        var fieldNum: u8 = 0;
        while (iterator.next()) |field| {
            try stdout.print("field {}\n", .{field});
            if (fieldNum == 1) {
                std.debug.print("Setting name to {}\n", .{field});
                p.name = field;
            } else if (fieldNum == 2) {
                std.debug.print("Setting father to {}\n", .{field});
                p.father = a.create(Person) catch @panic("Out of memory");
                p.father.* = Person{
                    .name = field,
                    .mother = undefined,
                    .father = undefined,
                };
            } else if (fieldNum == 3) {
                std.debug.print("Setting mother to {}\n", .{field});
                p.mother = a.create(Person) catch @panic("Out of memory");
                p.mother.* = Person{
                    .name = field,
                    .mother = undefined,
                    .father = undefined,
                };
            }
            fieldNum = fieldNum + 1;
        }
        std.debug.print("person is now {}\n", .{p.name});
        try stdout.print("Putting {} in hashmap\n", .{p.name});
        const hash = try a.alloc(u8, 64);
        var hasher = Blake3.init(.{});
        hasher.update(p.name);
        hasher.final(hash);
        try map.put(hash, p);
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

    const hash = try a.alloc(u8, 64);
    var hasher = Blake3.init(.{});
    hasher.update(target_person);
    hasher.final(hash);
    var result = map.get(hash);
    try stdout.print("result is: {}\n", .{result});
}
