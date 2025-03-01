const std = @import("std");

const enter: u32 = 13;

fn readline(buffer: []u8, stdin: anytype) !u32 {
    var character: u8 = 0;

    var i: u32 = 0;
    while (character != -1 and character != '\n') {
        character = try stdin.readByte();
        buffer[i] = character;
        i += 1;
    }

    return i;
}

pub fn main() !void {
    const max_input: u32 = comptime (256);

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const buffer: []u8 = try allocator.alloc(u8, max_input);
    var buffer_len: u32 = 0;

    var reprint_prompt: bool = true;

    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    while (true) {
        if (reprint_prompt == true) {
            try stdout.print("> ", .{});
        }

        buffer_len = try readline(buffer, stdin);
        if (buffer.len == 1) {
            switch (buffer[0]) {
                enter => {
                    reprint_prompt = true;
                },
                else => {},
            }
        } else {
            try stdout.print("{s}", .{buffer[0..buffer_len]});
        }
        @memset(buffer, 0);
    }
}
