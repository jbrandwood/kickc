// A raster IRQ that opens the top/bottom border.
#include <c64.h>

char* const GHOST_BYTE = $3fff;

void main() {
    *GHOST_BYTE = 0;
    asm { sei }
    // Disable CIA 1 Timer IRQ
    CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR;
    // Set raster line to $fa
    VICII->CONTROL1 &=$7f;
    VICII->RASTER = $fa;
    // Enable Raster Interrupt
    VICII->IRQ_ENABLE = IRQ_RASTER;
    // Set the IRQ routine
    *KERNEL_IRQ = &irq_bottom_1;
    asm { cli }
}

// Interrupt Routine 1
interrupt(kernel_min) void irq_bottom_1() {
    VICII->BORDER_COLOR = WHITE;
    // Set screen height to 24 lines - this is done after the border should have started drawing - so it wont start
    VICII->CONTROL1 &= ($ff^VIC_RSEL);
    // Acknowledge the IRQ
    VICII->IRQ_STATUS = IRQ_RASTER;
    // Trigger IRQ 2 at line $fd
    VICII->RASTER = $fd;
    *KERNEL_IRQ = &irq_bottom_2;
    VICII->BORDER_COLOR = RED;
}

// Interrupt Routine 2
interrupt(kernel_keyboard) void irq_bottom_2() {
    VICII->BORDER_COLOR = WHITE;
    // Set screen height back to 25 lines (preparing for the next screen)
    VICII->CONTROL1 |= VIC_RSEL;
    // Acknowledge the IRQ
    VICII->IRQ_STATUS = IRQ_RASTER;
    // Trigger IRQ 1 at line $fa
    VICII->RASTER = $fa;
    *KERNEL_IRQ = &irq_bottom_1;
    VICII->BORDER_COLOR = RED;
}