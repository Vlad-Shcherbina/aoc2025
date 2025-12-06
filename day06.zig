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
    for (inputs, &input_iters) |input, *input_iter| {
        input_iter.* = std.mem.tokenizeScalar(u8, input, ' ');
    }

    var part1: i64 = 0;
    while (ops_iter.next()) |op| {
        var xs: [k]i64 = undefined;
        for (&input_iters, &xs) |*input_iter, *x| {
            x.* = std.fmt.parseInt(i64, input_iter.next().?, 10) catch unreachable;
        }
        if (std.mem.eql(u8, op, "+")) {
            var s: i64 = 0;
            for (xs) |x| s += x;
            part1 += s;
        } else if (std.mem.eql(u8, op, "*")) {
            var p: i64 = 1;
            for (xs) |x| p *= x;
            part1 += p;
        } else unreachable;
    }
    for (&input_iters) |*input_iter| std.debug.assert(input_iter.next() == null);
    print("  part 1: {}\n", .{part1});

    var part2: i64 = 0;
    for (inputs) |input| std.debug.assert(input.len == ops.len);
    var current_op: ?u8 = null;
    var buffer: [10]i64 = undefined;
    var xs = std.ArrayListUnmanaged(i64).initBuffer(&buffer);
    for (ops, 0..) |op, i| {
        if (op != ' ') current_op = op;
        var x: i64 = 0;
        for (inputs) |input| {
            if (input[i] != ' ') {
                x *= 10;
                x += input[i] - '0';
            }
        }
        if (x == 0) { // all spaces
            part2 += reduce(xs.items, current_op);
            xs.clearRetainingCapacity();
        } else {
            xs.appendBounded(x) catch unreachable;
        }
    }
    part2 += reduce(xs.items, current_op);
    print("  part 2: {}\n", .{part2});
}

fn reduce(xs: []const i64, op: ?u8) i64 {
    if (op == '+') {
        var s: i64 = 0;
        for (xs) |x1| s += x1;
        return s;
    } else if (op == '*') {
        var p: i64 = 1;
        for (xs) |x1| p *= x1;
        return p;
    } else unreachable;
}
