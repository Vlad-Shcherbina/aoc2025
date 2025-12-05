const std = @import("std");
const print = std.debug.print;

pub fn solve(allocator: std.mem.Allocator) void {
    print("Day 5\n", .{});
    const data = std.fs.cwd().readFileAlloc(allocator, "data/day05.txt", 1024 * 1024) catch unreachable;
    defer allocator.free(data);
    const split = std.mem.indexOf(u8, data, "\n\n").?;

    const Range = struct { i64, i64 };
    var ranges = std.array_list.Managed(Range).init(allocator);
    defer ranges.deinit();

    var ranges_iter = std.mem.splitScalar(u8, data[0..split], '\n');
    while (ranges_iter.next()) |range| {
        const i = std.mem.indexOfScalar(u8, range, '-').?;
        const a = std.fmt.parseInt(i64, range[0..i], 10) catch unreachable;
        const b = std.fmt.parseInt(i64, range[i + 1 ..], 10) catch unreachable;
        ranges.append(.{ a, b }) catch unreachable;
    }

    var part1: i32 = 0;
    var ids_iter = std.mem.splitScalar(u8, std.mem.trimEnd(u8, data[split + 2 ..], "\n"), '\n');
    while (ids_iter.next()) |s| {
        const id = std.fmt.parseInt(i64, s, 10) catch unreachable;

        var fresh = false;
        for (ranges.items) |r| {
            if (r.@"0" <= id and id <= r.@"1") {
                fresh = true;
                break;
            }
        }
        if (fresh) part1 += 1;
    }
    print("  part 1: {}\n", .{part1});
}
