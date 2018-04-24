// Test that the compiler optimizes when the same parameter value is passed into a function in all calls

void main() {
    byte* screen = $400;
    const byte reverse = $80;
    screen[0] = sum(reverse, 'c');
    screen[1] = sum(reverse, 'm');
    screen[2] = sum(reverse, 'l');
}

byte sum(byte a, byte b) {
    return a+b;
}