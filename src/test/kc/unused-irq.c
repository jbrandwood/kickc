// Unused interrupts pointing to each other but never used from main loop - should be optimized away

byte* const SCREEN = 0x0400;

void main() {
    *SCREEN = 'x';
}

void()** const HARDWARE_IRQ = $fffe;

// Unused Interrupt Routine
interrupt void irq1() {
    *HARDWARE_IRQ = &irq2;
}

// Unused Interrupt Routine
interrupt void irq2() {
    *HARDWARE_IRQ = &irq1;
}