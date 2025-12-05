const std = @import("std");
const print = std.debug.print;

pub fn solve(allocator: std.mem.Allocator) void {
    print("Day 4\n", .{});
    const data = std.fs.cwd().readFileAlloc(allocator, "data/day04.txt", 1024 * 1024) catch unreachable;
    defer allocator.free(data);

    const trimmed = std.mem.trimEnd(u8, data, "\n");
    const h = std.mem.count(u8, trimmed, "\n") + 1 + 2;
    const w = std.mem.indexOfScalar(u8, trimmed, '\n').? + 2;
    var grid = allocator.alloc(u8, w * h) catch unreachable;
    var grid2 = allocator.alloc(u8, w * h) catch unreachable;
    defer allocator.free(grid);
    defer allocator.free(grid2);
    @memset(grid, 0);
    @memset(grid2, 0);
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
    var num_removed: i32 = 0;
    for (0..w * h) |iteration| {
        var changed = false;
        for (1..h - 1) |i| {
            for (1..w - 1) |j| {
                const idx = i * w + j;
                grid2[idx] = grid[idx];
                if (grid[idx] == 1) {
                    const s =
                        grid[idx - w - 1] + grid[idx - w] + grid[idx - w + 1] +
                        grid[idx - 1] + grid[idx + 1] +
                        grid[idx + w - 1] + grid[idx + w] + grid[idx + w + 1];
                    if (s < 4) {
                        grid2[idx] = 0;
                        num_removed += 1;
                        changed = true;
                    }
                }
            }
        }
        std.mem.swap([]u8, &grid, &grid2);
        if (iteration == 0) {
            print("  part 1: {}\n", .{num_removed});
        }
        if (!changed) {
            print("  part 2: {}\n", .{num_removed});
            break;
        }
    }
}
