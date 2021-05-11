// Unused interrupts pointing to each other but never used from main loop - should be optimized away

byte* const SCREEN = (char*)0x0400;

void main() {
    *SCREEN = 'x';
}

typedef void (*IRQ_TYPE)(void);
IRQ_TYPE * const HARDWARE_IRQ = (IRQ_TYPE*)$fffe;

// Unused Interrupt Routine
__interrupt void irq1() {
    *HARDWARE_IRQ = &irq2;
}

// Unused Interrupt Routine
__interrupt void irq2() {
    *HARDWARE_IRQ = &irq1;
}