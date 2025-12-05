const std = @import("std");
const print = std.debug.print;

pub fn solve(allocator: std.mem.Allocator) void {
    print("Day 4\n", .{});
    const data = std.fs.cwd().readFileAlloc(allocator, "data/day04.txt", 1024 * 1024) catch unreachable;
    defer allocator.free(data);

    const trimmed = std.mem.trimEnd(u8, data, "\n");
    const h = std.mem.count(u8, trimmed, "\n") + 1 + 2;
    const w = std.mem.indexOfScalar(u8, trimmed, '\n').? + 2;
    const grid = allocator.alloc(u8, w * h) catch unreachable;
    defer allocator.free(grid);
    @memset(grid, 0);
    {
        var lines = std.mem.splitScalar(u8, trimmed, '\n');
        var i: usize = 0;
        while (lines.next()) |line| {
            std.debug.assert(line.len + 2 == w);
            for (line, 0..) |c, j| {
                grid[(i + 1) * w + j + 1] = switch (c) {
                    '.' => 0,
                    '@' => 1,
                    else => unreachable,
                };
            }
            i += 1;
        }
        std.debug.assert(i + 2 == h);
    }
    var part1: i32 = 0;
    for (1..h - 1) |i| {
        for (1..w - 1) |j| {
            const idx = i * w + j;
            if (grid[idx] == 1) {
                const s =
                    grid[idx - w - 1] + grid[idx - w] + grid[idx - w + 1] +
                    grid[idx - 1] + grid[idx + 1] +
                    grid[idx + w - 1] + grid[idx + w] + grid[idx + w + 1];
                if (s < 4) {
                    part1 += 1;
                }
            }
        }
    }
    print("  part 1: {}\n", .{part1});
}
