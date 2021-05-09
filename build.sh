mkdir -p build/iso/boot/grub
zig build
cp build/zigboot build/iso/boot
cp grub.cfg build/iso/boot/grub/grub.cfg
grub-mkrescue -o x86_64-zigboot.iso build/iso