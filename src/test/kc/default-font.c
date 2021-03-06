// Show default font on screen

#include <string.h>

byte* SCREEN = (char*)0x0400;

void main() {
    memset(SCREEN, ' ', 1000);
    byte* screen = SCREEN + 40+1;
    byte ch = 0;
    for( byte x: 0..15) {
        for( byte y: 0..15) {
            *screen++ = ch++;
        }
        screen += (40-16);
    }
}