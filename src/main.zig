const std = @import("std");
const os = std.os;

fn unwrapArg(args: UnwrapArgError![]u8) UnwrapArgError![]u8 {
    return arg catch |err| {
        std.debug.warn("Unable to parse command line option: {}\n", err);
        return err;
    };
}

pub fn main() !void {
    var memory = []u8{0} ** 30000;
    var memory_pointer: u15 = 0;
    var args_it = os.args();
    // skip own exe name
    _ = args_it.skip();
    const program = try unwrapArg(args_it.next(allocator) orelse {
        std.debug.warn("Not gonna provide a program to run?");
        return error.InvalidArgs;
    });
    for (program) |operator| {
        switch (operator) {
            '+' => memory[memory_pointer] += 1,
            '-' => memory[memory_pointer] -= 1,
            '>' => memory_pointer += 1,
            '<' => memory_pointer -= 1,
            else => {},
        }
    }
    const std_out_file = try std.io.getStdOut();
    try std_out_file.outStream().stream.print("{}\n", memory[memory_pointer]);
}
