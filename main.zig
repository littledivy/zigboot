const Char = packed struct {
    char: u8,
    attr: u8,
};

// Called from the bootloader
export fn main() noreturn {
    // VGA physical address
    var vga = @intToPtr([*]Char, 0xb8000);
    // Paint the screen bright red.
    var i: usize = 0;
    while (i < 80 * 25) : (i += 1) {
        vga[i] = Char{
            .attr = 12 | (12 << 4),
            .char = ' ',
        };
    }

    var idx: usize = 0;
    while (true) {
        var status: u8 = inb(0x64);
        if (status & 0x1 == 0) {
            continue;
        }
        var scancode: u8 = inb(0x60);
        // TODO: scancode map
        // var key: u8 = parse_scancode(scancode);
        vga[idx] = Char{
            .attr = 0 | (12 << 4),
            .char = 'Z',
        };
        idx += 1;
    }
}

pub inline fn inb(port: u16) u8 {
    return asm volatile ("inb %[port], %[result]"
        : [result] "={al}" (-> u8)
        : [port] "N{dx}" (port)
    );
}

// Credits: https://github.com/jzck/kernel-zig/blob/33a6b9d3231b95a80a23402f10c14bd3db029606/src/multiboot.zig
const MultibootHeader = packed struct {
    magic: u32,
    flags: u32,
    checksum: u32,
};

// The multiboot header recognised by GRUB. See `linker.ld`
export const multiboot_header align(4) linksection(".multiboot") = multiboot: {
    const MAGIC: u32 = 0x1BADB002;
    const ALIGN: u32 = 1 << 0;
    const MEMINFO: u32 = 1 << 1;
    const FLAGS: u32 = ALIGN | MEMINFO;

    break :multiboot MultibootHeader{
        .magic = MAGIC,
        .flags = FLAGS,
        .checksum = ~(MAGIC +% FLAGS) +% 1,
    };
};
