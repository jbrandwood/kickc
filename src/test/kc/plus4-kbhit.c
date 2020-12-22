// Test implementation of kbhit() for Plus/4
#pragma target(plus4)
#include <plus4.h>

void main() {
    while(!kbhit()) {}
}

// Return true if there's a key waiting, return false if not
unsigned char kbhit (void) {
    // Read all keyboard matrix rows
    KEYBOARD_PORT->PORT = 0x00;
    // Write to the keyboard input to latch the matrix column values
    TED->KEYBOARD_INPUT = 0;
    // Read the keyboard input
    return ~TED->KEYBOARD_INPUT;
}