// Test that multiplication at runtime gives a proper error

void main() {
    byte* screen = (char*)$400;
    for (byte i: 2..5) {
        screen[i] = i*i;
    }
}