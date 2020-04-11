// Test the functionality of the C64 processor port ($00/$01)
// Tests by setting the value of the processor port - and then printing out values of $00/$01/$a000/$d000/$e000

#include <c64.c>
#include <print.c>

char* const BASIC_ROM = $a000;
char* const KERNAL_ROM = $e000;
char* const IO_RAM = $d000;
char* const SCREEN = 0x400;

void main() {
    // Avoid interrupts
    asm { sei }
    // Write recognizable values into memory
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_ALL;
    *BASIC_ROM = $a0;
    *KERNAL_ROM = $e0;
    *IO_RAM = $d0;
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_BASIC_KERNEL_IO;
    *IO_RAM = $dd;

    print_cls();
    print_str("ddr port ddr2 $00 $01 $a000 $d000 $e000");
    print_ln();
    testProcport(PROCPORT_DDR_MEMORY_MASK, PROCPORT_RAM_ALL, PROCPORT_DDR_MEMORY_MASK);
    testProcport(PROCPORT_DDR_MEMORY_MASK, PROCPORT_RAM_IO, PROCPORT_DDR_MEMORY_MASK);
    testProcport(PROCPORT_DDR_MEMORY_MASK, PROCPORT_RAM_CHARROM, PROCPORT_DDR_MEMORY_MASK);
    testProcport(PROCPORT_DDR_MEMORY_MASK, PROCPORT_KERNEL_IO, PROCPORT_DDR_MEMORY_MASK);
    testProcport(PROCPORT_DDR_MEMORY_MASK, PROCPORT_BASIC_KERNEL_IO, PROCPORT_DDR_MEMORY_MASK);

    testProcport($00, $00, $00);
    testProcport($ff, $00, $00);
    testProcport($ff, $ff, $00);

    testProcport($ff, $00, $ff);
    testProcport($ff, $55, $ff);
    testProcport($ff, $aa, $ff);
    testProcport($ff, $ff, $ff);

    testProcport($55, $00, $55);
    testProcport($55, $55, $55);
    testProcport($55, $ff, $55);

    testProcport($aa, $00, $aa);
    testProcport($aa, $ff, $aa);
    testProcport($aa, $aa, $aa);

    testProcport($ff, $d0, $00);
    testProcport($ff, $55, $55);
    testProcport($17, $15, $15);
    testProcport($17, $15, $17);
    testProcport($17, $17, $17);

    // Enable interrupts
    asm { cli }
    // Return to normal settings
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_BASIC_KERNEL_IO;

    while(true) (*(SCREEN+999))++;
}

void testProcport(char ddr, char port, char ddr2) {
    *PROCPORT_DDR = $ff;
    *PROCPORT = $00;
    *PROCPORT_DDR = ddr;
    *PROCPORT = port;
    *PROCPORT_DDR = ddr2;
    print_str(" ");
    print_byte(ddr);
    print_str("   ");
    print_byte(port);
    print_str("   ");
    print_byte(ddr2);
    print_str("  ");
    print_byte(*PROCPORT_DDR);
    print_str("  ");
    print_byte(*PROCPORT);
    print_str("    ");
    print_byte(*BASIC_ROM);
    print_str("    ");
    print_byte(*IO_RAM);
    print_str("    ");
    print_byte(*KERNAL_ROM);
    print_ln();
}
