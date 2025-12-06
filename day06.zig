const std = @import("std");
const print = std.debug.print;

pub fn solve(allocator: std.mem.Allocator) void {
    print("Day 6\n", .{});
    const data = std.fs.cwd().readFileAlloc(allocator, "data/day06.txt", 1024 * 1024) catch unreachable;
    defer allocator.free(data);

    var it = std.mem.splitScalar(u8, data, '\n');
    const k = 4;
    var inputs: [k][]const u8 = undefined;
    for (&inputs) |*input| {
        input.* = it.next().?;
    }
    const ops = it.next().?;
    const empty = it.next().?;
    std.debug.assert(empty.len == 0);

    var ops_iter: std.mem.TokenIterator(u8, .scalar) = std.mem.tokenizeScalar(u8, ops, ' ');
    var input_iters: [k]std.mem.TokenIterator(u8, .scalar) = undefined;
    for (&inputs, &input_iters) |input, *input_iter| {
        input_iter.* = std.mem.tokenizeScalar(u8, input, ' ');
    }

    var grand_total: i64 = 0;
    while (ops_iter.next()) |op| {
        var xs: [k]i64 = undefined;
        for (&input_iters, &xs) |*input_iter, *x| {
            x.* = std.fmt.parseInt(i64, input_iter.next().?, 10) catch unreachable;
        }
        if (std.mem.eql(u8, op, "+")) {
            var s: i64 = 0;
            for (&xs) |x| s += x;
            grand_total += s;
        } else if (std.mem.eql(u8, op, "*")) {
            var p: i64 = 1;
            for (&xs) |x| p *= x;
            grand_total += p;
        } else unreachable;
    }
    for (&input_iters) |*input_iter| std.debug.assert(input_iter.next() == null);
    print("  part 1: {}\n", .{grand_total});
}
