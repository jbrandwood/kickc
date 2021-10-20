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
                char k = i+j;
                if(k>0x80) {
                    VICII->BORDER_COLOR++;
                }
            }
    }
}

__mem char * volatile ptr = (char*)0xff00;


// The Interrupt Handler
__interrupt(rom_sys_c64) void irq() {
    *BG_COLOR = WHITE;
    (*ptr)++;
    *BG_COLOR = BLACK;
}