// Test declaring an array variable as at a hard-coded address

// The screen
char * const SCREEN = 0x0400;

// Data to be put on the screen
char __address(0x1000) DATA[1000];

void main() {
    SCREEN[0] = DATA[0];
}

