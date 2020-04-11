// Type mismatch - should fail gracefully
void main() {
    word w = 5000;
    byte b = w;
    byte* const screen = 0x0400;
    screen[0] = b;
}