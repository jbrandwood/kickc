// Test that forward-referencing an uninitialized variable inside a method fails.

void main() {
    const byte b = a;
    const byte a = 'c';
    byte* screen = $400;
    screen[0] = a;
    screen[1] = b;
}