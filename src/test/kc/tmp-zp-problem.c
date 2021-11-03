// Demonstrates a problem where temporary zp-variables are overwrites each other between different "threads"
#include <c64.h>
#include <6502.h>

// Setup the IRQ routine
void main() {
    SEI();
    *KERNEL_IRQ = &irq;
    CLI();

    for(;;) {
        for(char i=0;i<10;i++)
            for(char j=0;j<10;j++) {
                // i and j are put into X/Y. The A=X+Y fragment uses $ff as temporary storage.
                char k = i+j;
                if(k>0x80) {
                    // Problem: This will occasionally trigger due to the IRQ interfering with the value in $ff!
                    VICII->BORDER_COLOR++;
                }
            }
    }
}

__mem char * volatile ptr = (char*)0xff00;


// The Interrupt Handler
__interrupt(rom_sys_c64) void irq() {
    *BG_COLOR = WHITE;
    // ptr has to be moved to ZP for indirection. The fragment uses $fe-f as temporary storage.
    (*ptr)++;
    *BG_COLOR = BLACK;
}