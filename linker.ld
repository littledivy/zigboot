ENTRY(__start)

SECTIONS {
	/* ensure that the multiboot header is at the beginning */
	.multiboot :
	{
		/* KEEP otherwise it gets garbage collected by linker */
		KEEP(*(.multiboot))
		. = ALIGN(4K);
	}

	.text :
	{
		*(.text .text.*)
		. = ALIGN(4K);
	}

	.rodata :
	{
		*(.rodata .rodata.*)
		. = ALIGN(4K);
	}


	.bss :
	{
		*(.bss .bss.*)
		. = ALIGN(4K);
	}
}