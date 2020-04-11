// Test that inline interrupts not allowed

byte* SCREEN = $400;

void main() {
    SCREEN[0]++;
}

interrupt byte irq() {
    SCREEN[1]++;
    return 2;
}