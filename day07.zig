const std = @import("std");
const print = std.debug.print;

pub fn solve(allocator: std.mem.Allocator) void {
    print("Day 7\n", .{});
    const data = std.fs.cwd().readFileAlloc(allocator, "data/day07.txt", 1024 * 1024) catch unreachable;
    defer allocator.free(data);

    var lines = std.mem.splitScalar(u8, std.mem.trim(u8, data, "\n"), '\n');
    const start_line = lines.next().?;

    const buf = allocator.alloc(Pair, start_line.len) catch unreachable;
    const buf2 = allocator.alloc(Pair, start_line.len) catch unreachable;
    defer allocator.free(buf);
    defer allocator.free(buf2);
    var tachions = std.ArrayList(Pair).initBuffer(buf);
    var tachions2 = std.ArrayList(Pair).initBuffer(buf2);

    const start = std.mem.indexOfScalar(u8, start_line, 'S').?;
    tachions.appendBounded(.{ .idx = start, .cnt = 1 }) catch unreachable;

    var part1: i32 = 0;
    while (lines.next()) |line| {
        tachions2.clearRetainingCapacity();
        for (tachions.items) |p| {
            switch (line[p.idx]) {
                '.' => {
                    add_last(&tachions2, p);
                },
                '^' => {
                    part1 += 1;
                    add_last(&tachions2, .{ .idx = p.idx - 1, .cnt = p.cnt });
                    add_last(&tachions2, .{ .idx = p.idx + 1, .cnt = p.cnt });
                },
                else => unreachable,
            }
        }
        std.mem.swap(std.ArrayList(Pair), &tachions, &tachions2);
    }
    print("  part 1: {}\n", .{part1});
    var part2: i64 = 0;
    for (tachions.items) |p| part2 += p.cnt;
    print("  part 2: {}\n", .{part2});
}

const Pair = struct {
    idx: usize,
    cnt: i64,
};

fn add_last(xs: *std.ArrayList(Pair), p: Pair) void {
    if (xs.items.len > 0 and xs.items[xs.items.len - 1].idx == p.idx) {
        xs.items[xs.items.len - 1].cnt += p.cnt;
    } else {
        xs.appendBounded(p) catch unreachable;
    }
}
