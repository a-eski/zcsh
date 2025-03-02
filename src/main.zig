const std = @import("std");

const mem = std.mem;

// Input
const enter: u32 = 13;

// Constants
const MaxInputLen: u32 = 256;
const MaxArgLen: u32 = 32;
const MaxArgs: u32 = 10;

const Input = struct {
    buffer: []u8,
    buffer_len: u32,

    pub fn init(allocator: mem.Allocator) !Input {
        return Input{
            .buffer = try allocator.alloc(u8, MaxInputLen),
            .buffer_len = 0,
        };
    }

    pub fn reset(self: *Input) void {
        @memset(self.buffer, 0);
        self.buffer_len = 0;
    }

    pub fn debug(self: *Input, stdout: anytype) !void {
        try stdout.print("{s}", .{self.buffer[0..self.buffer_len]});
    }
};

const Output = struct {
    args: [][]u8,
    args_len: u32,

    pub fn init(allocator: mem.Allocator) !Output {
        const output: Output = Output{
            .args = try allocator.alloc([]u8, MaxArgs),
            .args_len = 0,
        };

        for (output.args) |*arg| {
            arg.* = try allocator.alloc(u8, MaxArgLen);
        }

        return output;
    }

    pub fn reset(self: *Output) void {
        for (self.args) |arg| {
            @memset(arg, 0);
        }
        self.args_len = 0;
    }

    pub fn debug(self: *Output, stdout: anytype) !void {
        var i: u32 = 0;
        while (i < self.args_len) {
            try stdout.print("{s}", self.args[i]);
            i += 1;
        }
    }
};

fn readline(input: *Input, stdin: anytype) !void {
    var character: u8 = 0;

    var i: u32 = 0;
    while (character != -1 and character != '\n') {
        character = try stdin.readByte();
        input.buffer[i] = character;
        i += 1;
    }

    input.buffer_len = i;
}

fn parse(input: *Input, output: *Output) void {
    // const trimmed_input =
    // mem.trim(u8, input.buffer[0..input.buffer_len], .{' '});
    var i: u32 = 0;
    var o: [][]u8 = undefined;
    const parts = mem.splitScalar(u8, input.buffer, ' ');
    for (parts) |part| {
        o[i] = part;
        i += 1;
    }
    output.args_len = i;
    // var iterator = mem.splitScalar(u8, input.buffer, ' ');
    // var i: u32 = 0;
    // while (iterator.next()) |arg| {
    // output.args[i] = @constCast(arg);
    // output.args[i] = arg;
    // i += 1;
    // }

    // for (output.args) |*arg| {
    // arg = iterator.next() orelse break;
    // i += 1;
    // }

    // var i: u32 = 0;
    // while (it.next()) |arg| {
    // @memcpy(output.args[i][0..arg.len], arg[0..arg.len]);
    // @memcpy(output.args + i)[0..arg.len], arg[0..arg.len]);
    // @memcpy(.{output.args[i]}, .{arg});
    // @memcpy(&output.args[i], &arg);
    // @memcpy(.{output.args[i][0..arg.len]}, .{arg[0..arg.len]});
    // @memcpy(output.args[i][0..arg.len], arg[0..arg.len]);
    // output.args[i] = arg[0..arg.len];
    // output.args[i] = @constCast(arg[0..arg.len]);
    // var j: u32 = 0;
    // while (j < arg.len) {
    //     output.args[i][j] = arg[j];
    //     j += 1;
    // }
    // output.args[i] = @constCast(arg.ptr);
    // output.args[i].ptr = @constCast(arg.ptr);
    // i += 1;
    // }
    // var slice: []const u8 = it.next() orelse return;
    // while (slice.len > 0) {
    //     output.args[i] = @constCast(slice);
    //     @memcpy(output.args[i], arg);
    //     output.args[i] = arg;
    //     slice = it.next();
    //     i += 1;
    // }

    // output.args_len = i;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var input: Input = try Input.init(allocator);
    var output: Output = try Output.init(allocator);

    var reprint_prompt: bool = true;

    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    while (true) {
        if (reprint_prompt == true) {
            try stdout.print("> ", .{});
        }

        try readline(&input, stdin);
        if (input.buffer.len == 1) {
            switch (input.buffer[0]) {
                enter => {
                    reprint_prompt = true;
                },
                else => {},
            }
        } else {
            try input.debug(stdout);
            // parse(&input, &output);
            // try output.debug(stdout);
        }

        input.reset();
        output.reset();
    }
}
