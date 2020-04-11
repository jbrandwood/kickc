// A minimal working raster hardware IRQ with clobber-based register savings
#include <c64.h>

void main() {
    asm { sei }
    // Disable kernal & basic
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
    // Disable CIA 1 Timer IRQ
    *CIA1_INTERRUPT = CIA_INTERRUPT_CLEAR;
    // Set raster line to $100
    *VIC_CONTROL |=$80;
    *RASTER = $00;
    // Enable Raster Interrupt
    *IRQ_ENABLE = IRQ_RASTER;
    // Set the IRQ routine
    *HARDWARE_IRQ = &irq;
    asm { cli }
    while(true) {
        (*BORDERCOL)++;
    }
}

// Interrupt Routine
interrupt(hardware_clobber) void irq() {
    do_irq();
}

void do_irq() {
    *BGCOL = WHITE;
    *BGCOL = BLACK;
    // Acknowledge the IRQ
    *IRQ_STATUS = IRQ_RASTER;
}