// Called from the bootloader
export fn main() void {
  // VGA physical address
  var vga = @intToPtr([*]u16, 0xb8000);
  // Paint the screen bright red.
  var i: usize = 0;
  while (i < 80 * 25): (i += 1) {
    vga[i] = 12 << 12;
  }  
}

// Credits: https://github.com/jzck/kernel-zig/blob/33a6b9d3231b95a80a23402f10c14bd3db029606/src/multiboot.zig
const MultibootHeader = packed struct {
    magic:    u32,
    flags:    u32,
    checksum: u32,
};

// The multiboot header recognised by GRUB. See `linker.ld`
export const multiboot_header align(4) linksection(".multiboot") = multiboot: {
    const MAGIC: u32   = 0x1BADB002;
    const ALIGN: u32   = 1 << 0;
    const MEMINFO: u32 = 1 << 1;
    const FLAGS: u32   = ALIGN | MEMINFO;

    break :multiboot MultibootHeader {
        .magic    = MAGIC,
        .flags    = FLAGS,
        .checksum = ~(MAGIC +% FLAGS) +% 1,
    };
};
