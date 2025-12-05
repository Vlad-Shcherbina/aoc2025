const std = @import("std");
const print = std.debug.print;

pub fn solve(allocator: std.mem.Allocator) void {
    print("Day 5\n", .{});
    const data = std.fs.cwd().readFileAlloc(allocator, "data/day05.txt", 1024 * 1024) catch unreachable;
    defer allocator.free(data);
    const split = std.mem.indexOf(u8, data, "\n\n").?;

    const Range = struct { lo: i64, hi: i64 };
    var ranges = std.array_list.Managed(Range).init(allocator);
    defer ranges.deinit();
    var ranges_iter = std.mem.splitScalar(u8, data[0..split], '\n');
    while (ranges_iter.next()) |range| {
        const i = std.mem.indexOfScalar(u8, range, '-').?;
        const a = std.fmt.parseInt(i64, range[0..i], 10) catch unreachable;
        const b = std.fmt.parseInt(i64, range[i + 1 ..], 10) catch unreachable;
        ranges.append(.{ .lo = a, .hi = b }) catch unreachable;
    }

    var part1: i32 = 0;
    var ids_iter = std.mem.splitScalar(u8, std.mem.trimEnd(u8, data[split + 2 ..], "\n"), '\n');
    while (ids_iter.next()) |s| {
        const id = std.fmt.parseInt(i64, s, 10) catch unreachable;

        var fresh = false;
        for (ranges.items) |r| {
            if (r.lo <= id and id <= r.hi) {
                fresh = true;
                break;
            }
        }
        if (fresh) part1 += 1;
    }
    print("  part 1: {}\n", .{part1});

    const Endpoint = struct { x: i64, is_left: bool };
    const endpoints = allocator.alloc(Endpoint, ranges.items.len * 2) catch unreachable;
    defer allocator.free(endpoints);
    for (ranges.items, 0..) |r, i| {
        endpoints[2 * i] = .{ .x = r.lo, .is_left = true };
        endpoints[2 * i + 1] = .{ .x = r.hi + 1, .is_left = false };
    }
    std.mem.sort(Endpoint, endpoints, {}, struct {
        fn lessThan(_: void, a: Endpoint, b: Endpoint) bool {
            return a.x < b.x or a.x == b.x and a.is_left and !b.is_left;
        }
    }.lessThan);
    var k: i32 = 0;
    var part2: i64 = 0;
    for (endpoints) |e| {
        if (e.is_left) {
            if (k == 0) part2 -= e.x;
            k += 1;
        } else {
            k -= 1;
            if (k == 0) part2 += e.x;
        }
    }
    print("  part 2: {}\n", .{part2});
}
