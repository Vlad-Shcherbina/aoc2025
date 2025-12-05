const std = @import("std");
const print = std.debug.print;
const day01 = @import("day01.zig");
const day02 = @import("day02.zig");
const day03 = @import("day03.zig");

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    day01.solve(allocator);
    day02.solve();
    day03.solve(allocator);
}

test "deps" {
    // referencing the module makes the compiler analyze it (and include its tests)
    _ = day01;
}
