// Test that inline interrupts not allowed

byte* SCREEN = $400;

void main() {
    SCREEN[0]++;
    irq();
}

interrupt void irq() {
    SCREEN[1]++;
}