// Test declaring an integer array variable as at a hard-coded address

// The screen
int * const SCREEN = 0x0400;

// Data to be put on the screen
int __address(0x1000) DATA[1000];

void main() {
    SCREEN[0] = DATA[0];
}

