// Test reading keyboard port on the TED of the Plus/4
#pragma target(plus4)

#include <string.h>

// Keyboard latch
char * const KEYBOARD_INPUT = (char*)0xff08;
// Keyboard scan
char * const KEYBOARD_SCAN = (char*)0xfd30;
// Default address of screen character matrix
char * const DEFAULT_SCREEN = (char*)0x0c00;

void main() {
    asm { sei }
    memset(DEFAULT_SCREEN, ' ', 0x0400);
    while(1) {
        char * row = DEFAULT_SCREEN;
        for(char y=0;y<8;y++) {
            *KEYBOARD_SCAN = 0xff^(1<<y);
            *KEYBOARD_INPUT = 0;
            char key_bit = *KEYBOARD_INPUT^0xff;
            for(char x=0;x<8;x++) {
                if(key_bit&0x80) 
                    row[x] = '*';
                key_bit <<= 1;
            }
            row += 40;
        }
    }
}