const std = @import("std");

pub fn main() !void {
    const max_input: u32 = 256;

    // var character: u32 = 0;
    // var temp_character: u32 = 0;
    var buffer: [max_input]u8 = undefined;
    // var buffer_position: u32 = 0;
    // var buffer_start: u32 = 0;
    // var max_buffer_position: u32 = 0;

    var reprint_prompt: bool = true;

    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    while (true) {
        if (reprint_prompt == true) {
            try stdout.print("> ", .{});
        }
        const result = try stdin.readUntilDelimiter(&buffer, '\n');
        _ = result;

        if (buffer.len == 1) {
            switch (buffer[0]) {
                4 => {
                    break;
                },
                13 => {
                    reprint_prompt = true;
                },
            }
        }

        // try stdout.print("{s}", .{buffer[0..result.len]});
    }
}
