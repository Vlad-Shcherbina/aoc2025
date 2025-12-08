const std = @import("std");
const print = std.debug.print;
const day01 = @import("day01.zig");
const day02 = @import("day02.zig");
const day03 = @import("day03.zig");
const day04 = @import("day04.zig");
const day05 = @import("day05.zig");
const day06 = @import("day06.zig");
const day07 = @import("day07.zig");
const day08 = @import("day08.zig");

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    day01.solve(allocator);
    day02.solve();
    day03.solve(allocator);
    day04.solve(allocator);
    day05.solve(allocator);
    day06.solve(allocator);
    day07.solve(allocator);
    day08.solve(allocator);
}

test "deps" {
    // referencing the module makes the compiler analyze it (and include its tests)
    _ = day01;
}
