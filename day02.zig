const std = @import("std");
const print = std.debug.print;

pub fn solve() void {
    print("Day 2\n", .{});
    const data = @embedFile("data/day02.txt");
    var part1: u64 = 0;
    var part2: u64 = 0;
    var ranges = std.mem.splitScalar(u8, std.mem.trim(u8, data, "\n"), ',');
    while (ranges.next()) |range| {
        var it = std.mem.splitScalar(u8, range, '-');
        const left = std.fmt.parseInt(u64, it.next().?, 10) catch unreachable;
        const right = std.fmt.parseInt(u64, it.next().?, 10) catch unreachable;
        if (it.next() != null) unreachable;
        var buf: [20]u8 = undefined;
        for (left..right + 1) |id| {
            const s = std.fmt.bufPrint(&buf, "{}", .{id}) catch unreachable;
            var valid = true;
            for (2..s.len + 1) |d| {
                if (s.len % d > 0) continue;
                const len = s.len / d;
                const all_eq = std.mem.eql(u8, s[0 .. s.len - len], s[len..]);
                if (all_eq) {
                    if (d == 2) part1 += id;
                    valid = false;
                    break;
                }
            }
            if (!valid) part2 += id;
        }
    }
    print("  part 1: {}\n", .{part1});
    print("  part 2: {}\n", .{part2});
}
