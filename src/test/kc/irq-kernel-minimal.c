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
    *BGCOL = WHITE;
    *BGCOL = BLACK;
}