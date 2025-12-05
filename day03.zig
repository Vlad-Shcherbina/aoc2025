const std = @import("std");
const print = std.debug.print;

fn max_combination(line: []const u8, size: usize) i64 {
    var t: i64 = 0;
    var idx: usize = 0;
    for (0..size) |i| {
        for (idx + 1..line.len - size + i + 1) |j| {
            if (line[j] > line[idx]) {
                idx = j;
            }
        }
        t *= 10;
        t += line[idx] - '0';
        idx += 1;
    }
    return t;
}

pub fn solve(allocator: std.mem.Allocator) void {
    print("Day 3\n", .{});
    const data = std.fs.cwd().readFileAlloc(allocator, "data/day03.txt", 1024 * 1024) catch unreachable;
    defer allocator.free(data);

    var part1: i64 = 0;
    var part2: i64 = 0;
    var lines = std.mem.splitScalar(u8, std.mem.trimEnd(u8, data, "\n"), '\n');
    while (lines.next()) |line| {
        part1 += max_combination(line, 2);
        part2 += max_combination(line, 12);
    }
    print("  part 1: {}\n", .{part1});
    print("  part 2: {}\n", .{part2});
}
