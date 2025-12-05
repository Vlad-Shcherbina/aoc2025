const print = @import("std").debug.print;
const day01 = @import("day01.zig");
const std = @import("std");

pub fn main() void {
    day01.solve();
}

test "deps" {
    // referencing the module makes the compiler analyze it (and include its tests)
    _ = day01;
}
