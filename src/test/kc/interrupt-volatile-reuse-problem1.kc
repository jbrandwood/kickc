// Illustrates problem where volatiles reuse the same ZP addresses for multiple overlapping volatiles
void()** const  KERNEL_IRQ = $0314;
byte* const SCREEN=$400;
volatile byte col1 = 0;
volatile byte col2 = 8;

void main() {
    *KERNEL_IRQ = &irq;
}

interrupt void irq() {
    SCREEN[40] = col1++;
    SCREEN[41] = col2++;
}
