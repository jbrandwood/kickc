// Test declaring an address as expression

// The screen
char * const SCREEN = 0x0400;


word const var1 = 0x800;
word const var2 = 0x900;

// Data to be put on the screen
char __address(var1 + var2) DATA[1000];

void main() {
    SCREEN[0] = DATA[0];
}
