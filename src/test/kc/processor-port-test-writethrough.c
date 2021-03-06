// Test the write through to RAM when writing to VIC/CIA/colorram

#include <c64.h>
#include <c64-print.h>

void main() {
    // Avoid interrupts
    asm { sei }
    // Setup DDR-register
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;

    print_cls();
    print_str("testing ram write through on i/o");
    print_ln();
    print_ln();
    print_str("name  address  writethrough");
    print_ln();
    testWritethrough("vic  ", 0xd000);
    testWritethrough("sid  ", 0xd400);
    testWritethrough("cia  ", 0xd800);
    testWritethrough("color", 0xdc00);

    // Enable interrupts
    asm { cli }
    // Return to normal settings
    *PROCPORT = PROCPORT_BASIC_KERNEL_IO;
}

void testWritethrough(char* name, char* address) {
    // Test the write-through

    const char RAM_VALUE = 0x55;
    const char IO_VALUE = 0xaa;

    // Write known value to RAM
    *PROCPORT = PROCPORT_RAM_ALL;
    *address = RAM_VALUE;
    // Write another value to I/O
    *PROCPORT = PROCPORT_RAM_IO;
    *address = IO_VALUE;
    // Read value from RAM
    *PROCPORT = PROCPORT_RAM_ALL;
    char ramValue = *address;

    print_str(name);
    print_str(" ");
    print_uint((unsigned int)address);
    print_str("     ");
    if(ramValue==IO_VALUE)
        print_str("yes");
    else
        print_str("no");

    print_ln();
}
