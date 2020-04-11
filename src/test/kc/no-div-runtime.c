// Test that division at runtime gives a proper error

void main() {
    byte* screen = $400;
    for (byte i: 2..5) {
        screen[i] = 100/i;
    }
}