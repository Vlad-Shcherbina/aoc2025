const std = @import("std");
const print = std.debug.print;

pub fn solve(allocator: std.mem.Allocator) void {
    print("Day 3\n", .{});
    const data = std.fs.cwd().readFileAlloc(allocator, "data/day03.txt", 1024 * 1024) catch unreachable;
    defer allocator.free(data);

    var part1: i32 = 0;
    var lines = std.mem.splitScalar(u8, std.mem.trimEnd(u8, data, "\n"), '\n');
    while (lines.next()) |line| {
        var idx1: usize = 0;
        for (1..line.len - 1) |i| {
            if (line[i] > line[idx1]) {
                idx1 = i;
            }
        }
        var idx2 = idx1 + 1;
        for (idx1 + 2..line.len) |i| {
            if (line[i] > line[idx2]) {
                idx2 = i;
            }
        }
        const t = (line[idx1] - '0') * 10 + line[idx2] - '0';
        part1 += t;
    }
    print("  part 1: {}\n", .{part1});
}
