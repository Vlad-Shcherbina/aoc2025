const std = @import("std");
const print = std.debug.print;

pub fn solve(allocator: std.mem.Allocator) void {
    print("Day 7\n", .{});
    const data = std.fs.cwd().readFileAlloc(allocator, "data/day07.txt", 1024 * 1024) catch unreachable;
    defer allocator.free(data);

    var lines = std.mem.splitScalar(u8, std.mem.trim(u8, data, "\n"), '\n');
    const start_line = lines.next().?;

    const buf = allocator.alloc(usize, start_line.len) catch unreachable;
    const buf2 = allocator.alloc(usize, start_line.len) catch unreachable;
    defer allocator.free(buf);
    defer allocator.free(buf2);
    var tachions = std.ArrayList(usize).initBuffer(buf);
    var tachions2 = std.ArrayList(usize).initBuffer(buf2);

    const start = std.mem.indexOfScalar(u8, start_line, 'S').?;
    tachions.appendBounded(start) catch unreachable;

    var part1: i32 = 0;
    while (lines.next()) |line| {
        tachions2.clearRetainingCapacity();
        for (tachions.items) |i| {
            switch (line[i]) {
                '.' => {
                    if (last(usize, tachions2.items) != i) {
                        tachions2.appendBounded(i) catch unreachable;
                    }
                },
                '^' => {
                    part1 += 1;
                    if (last(usize, tachions2.items) != i - 1) {
                        tachions2.appendBounded(i - 1) catch unreachable;
                    }
                    tachions2.appendBounded(i + 1) catch unreachable;
                },
                else => unreachable,
            }
        }
        std.mem.swap(std.ArrayList(usize), &tachions, &tachions2);
    }
    print("  part 1: {}\n", .{part1});
}

fn last(T: type, xs: []const T) ?T {
    if (xs.len == 0) {
        return null;
    } else {
        return xs[xs.len - 1];
    }
}
