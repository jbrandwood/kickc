// Test that inline interrupts not allowed

byte* SCREEN = $400;

void main() {
    SCREEN[0]++;
}

__interrupt void irq(byte b) {
    SCREEN[1]++;
}