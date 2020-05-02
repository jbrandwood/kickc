// A minimal working IRQ

#include <c64.h>

// Setup the IRQ routine
void main() {
    asm { sei }
    *KERNEL_IRQ = &irq;
    asm { cli }
}

// The Interrupt Handler
interrupt(kernel_keyboard) void irq() {
    *BG_COLOR = WHITE;
    *BG_COLOR = BLACK;
}