// Test that a local array with a fixed location results in an error

int * const SCREEN = 0x0400;

void main() {
    // Local data array at hard-coded location should produce an error
    int __address(0x1000) DATA[1000];
    SCREEN[0] = DATA[0];
}

