// Test that inline interrupts not allowed

byte* SCREEN = $400;

void main() {
    SCREEN[0]++;
}

__interrupt byte irq() {
    SCREEN[1]++;
    return 2;
}