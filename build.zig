const std = @import("std");

pub fn build(b: *std.Build) void {
    b.reference_trace = 100;

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "main",
        .root_module = b.createModule(.{
            .root_source_file = b.path("main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const tests = b.addTest(.{
        .root_module = exe.root_module,
    });

    const check = b.step("check", "Check if the executable and the tests compile");
    check.dependOn(&exe.step);
    check.dependOn(&tests.step);

    b.default_step = check;
}
