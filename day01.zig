const std = @import("std");
const print = std.debug.print;

pub fn solve(allocator: std.mem.Allocator) void {
    const data = std.fs.cwd().readFileAlloc(allocator, "data/day01.txt", 1024 * 1024) catch unreachable;
    defer allocator.free(data);

    var lines = std.mem.splitScalar(u8, std.mem.trim(u8, data, "\n"), '\n');
    var dial: i32 = 50;
    var part1: i32 = 0;
    var part2: i32 = 0;
    while (lines.next()) |line| {
        const dist = std.fmt.parseInt(u32, line[1..], 10) catch unreachable;
        switch (line[0]) {
            'L' => {
                for (0..dist) |_| {
                    dial -= 1;
                    if (dial == 0) {
                        part2 += 1;
                    }
                    if (dial < 0) {
                        dial += 100;
                    }
                }
            },
            'R' => {
                for (0..dist) |_| {
                    dial += 1;
                    if (dial >= 100) {
                        dial -= 100;
                    }
                    if (dial == 0) {
                        part2 += 1;
                    }
                }
            },
            else => unreachable,
        }
        if (dial == 0) {
            part1 += 1;
        }
    }
    print("Part 1: {}\n", .{part1});
    print("Part 2: {}\n", .{part2});
}
