const std = @import("std");

const io = std.io;
const os = std.os;

pub fn main() !void {
    const a = std.heap.page_allocator;
    const stdout = std.io.getStdOut().outStream();
    const stream = &std.io.getStdIn().inStream();

    var args_it = std.process.args();
    _ = args_it.skip();
    var word: []u8 = undefined;

    // TODO(dmiller): this arg handling could probably be simplified
    // but for now just grab the first one
    while (args_it.next(a)) |arg_or_err| {
        const arg = try arg_or_err;
        try stdout.print("word is: {}\n", .{arg});
        word = arg;
        break;
    }

    var buf: [1024]u8 = undefined;

    var nextIndexToMatch: usize = 0;

    var size = try stream.readAll(&buf);
    // loop until EOF hit
    while (size > 0) : (size = (try stream.readAll(&buf))) {
        var subSlice = buf[0..size];
        try stdout.print("Searching through {}\n", .{subSlice});
        try stdout.print("Word length is {}\n", .{word.len});

        for (subSlice) |c| {
            try stdout.print("Currently at index {} in word\n", .{nextIndexToMatch});

            var nextCharToMatch = word[nextIndexToMatch];
            try stdout.print("Checking if {} matches {}\n", .{ nextCharToMatch, c });
            if (c == nextCharToMatch) {
                try stdout.print("Matches. Advancing to next character\n", .{});
                nextIndexToMatch = nextIndexToMatch + 1;
                if (nextIndexToMatch + 1 == word.len) {
                    try stdout.print("WE FOUND THE WORD\n", .{});
                    os.exit(0);
                }
            } else {
                nextIndexToMatch = 0;
            }
        }
    }

    try stdout.print("We didn't find the word :(", .{});
    os.exit(1);
}
