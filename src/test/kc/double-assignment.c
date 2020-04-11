// Test that a double-assignment works.

void main() {
    byte a;
    byte b;
    byte* screen = $400;
    a = b = 12;
    screen[0] = a;
    screen[1] = b;

}