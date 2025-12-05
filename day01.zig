const std = @import("std");
const print = @import("std").debug.print;

pub fn solve() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const data = std.fs.cwd().readFileAlloc(allocator, "data/day01.txt", 1024 * 1024) catch unreachable;
    defer allocator.free(data);

    var lines = std.mem.splitScalar(u8, data, '\n');
    var dial: i32 = 50;
    var res: i32 = 0;
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        const dist = std.fmt.parseInt(i32, line[1..], 10) catch unreachable;
        switch (line[0]) {
            'L' => dial -= dist,
            'R' => dial += dist,
            else => unreachable,
        }
        dial = @mod(dial, 100);
        if (dial == 0) {
            res += 1;
        }
    }
    print("Part 1: {}\n", .{res});
}
