const std = @import("std");
const print = std.debug.print;

pub fn solve(allocator: std.mem.Allocator) void {
    print("Day 8\n", .{});
    const data = std.fs.cwd().readFileAlloc(allocator, "data/day08.txt", 1024 * 1024) catch unreachable;
    defer allocator.free(data);

    const Pt = [3]i64;
    var pts = std.ArrayList(Pt).empty;
    defer pts.deinit(allocator);
    var lines = std.mem.splitScalar(u8, std.mem.trimEnd(u8, data, "\n"), '\n');
    while (lines.next()) |line| {
        var it = std.mem.splitScalar(u8, line, ',');
        const x = std.fmt.parseInt(i64, it.next().?, 10) catch unreachable;
        const y = std.fmt.parseInt(i64, it.next().?, 10) catch unreachable;
        const z = std.fmt.parseInt(i64, it.next().?, 10) catch unreachable;
        std.debug.assert(it.next() == null);
        pts.append(allocator, .{ x, y, z }) catch unreachable;
    }

    const Edge = struct {
        a: usize,
        b: usize,
        dist2: i64,
    };
    var edges = std.ArrayList(Edge).empty;
    defer edges.deinit(allocator);
    for (pts.items, 0..) |pa, i| {
        for (pts.items[0..i], 0..) |pb, j| {
            const dx = pa[0] - pb[0];
            const dy = pa[1] - pb[1];
            const dz = pa[2] - pb[2];
            const dist2 = dx * dx + dy * dy + dz * dz;
            edges.append(allocator, .{ .a = i, .b = j, .dist2 = dist2 }) catch unreachable;
        }
    }
    std.mem.sort(Edge, edges.items, {}, struct {
        fn lessThan(_: void, a: Edge, b: Edge) bool {
            return a.dist2 < b.dist2;
        }
    }.lessThan);

    const buf = allocator.alloc(usize, pts.items.len) catch unreachable;
    defer allocator.free(buf);
    var dsu = DSU.init(buf);
    var num_components: usize = pts.items.len;
    for (edges.items, 1..) |edge, i| {
        if (dsu.find(edge.a) != dsu.find(edge.b)) {
            dsu.merge(edge.a, edge.b);
            num_components -= 1;
            if (num_components == 1) {
                print("  part 2: {}\n", .{pts.items[edge.a][0] * pts.items[edge.b][0]});
                break;
            }
        }
        if (i == 1000) {
            const sizes = allocator.alloc(usize, pts.items.len) catch unreachable;
            defer allocator.free(sizes);
            @memset(sizes, 0);
            for (0..pts.items.len) |j| {
                sizes[dsu.find(j)] += 1;
            }
            std.mem.sort(usize, sizes, {}, struct {
                fn lessThan(_: void, a: usize, b: usize) bool {
                    return a > b;
                }
            }.lessThan);
            print("  part 1: {}\n", .{sizes[0] * sizes[1] * sizes[2]});
        }
    }
}

const DSU = struct {
    parent: []usize,
    fn init(buf: []usize) DSU {
        for (buf, 0..) |*p, i| {
            p.* = i;
        }
        return DSU{ .parent = buf };
    }
    fn find(self: *DSU, x: usize) usize {
        if (self.parent[x] != x) {
            self.parent[x] = self.find(self.parent[x]);
        }
        return self.parent[x];
    }
    fn merge(self: *DSU, a: usize, b: usize) void {
        const ra = self.find(a);
        const rb = self.find(b);
        self.parent[ra] = rb;
    }
};

fn dbg(name: []const u8, p: anytype) void {
    print("{s} = {any}\n", .{ name, p });
}
