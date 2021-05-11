// Test that bitwise NOT (~) is handled correctly

void main() {
    char* const screen = (char*)0x0400;
    char b = ~0x10;
    *screen = b;
}