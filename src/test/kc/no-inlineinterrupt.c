// Test that inline interrupts not allowed

byte* SCREEN = (char*)$400;

void main() {
    SCREEN[0]++;
}

inline __interrupt void irq() {
    SCREEN[1]++;
}