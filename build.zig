const Builder = @import("std").build.Builder;
const builtin = @import("builtin");
const std = @import("std");

pub fn build(b: *Builder) void {
    const kernel = b.addExecutable("zigboot", "main.zig");
    kernel.setOutputDir("build");

    kernel.addAssemblyFile("boot.s");
    
    kernel.setBuildMode(b.standardReleaseOptions());
    kernel.setTarget(std.zig.CrossTarget{
            .cpu_arch = std.Target.Cpu.Arch.i386,
            .os_tag = std.Target.Os.Tag.freestanding,
            .abi = std.Target.Abi.none,
            .cpu_model = std.build.Target.CpuModel.determined_by_cpu_arch,
    });
    
    kernel.setLinkerScriptPath("linker.ld");
    b.default_step.dependOn(&kernel.step);
}
