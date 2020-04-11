// Test that struct variable and members can both have type directives

volatile struct { const char x;  char z;} y = { 1, 2 };

char* const SCREEN = 0x0400;

void main() {
    SCREEN[0] = y.x;
    SCREEN[0] = y.z;
}