// Shows a font where each char contains the number of the char (00-ff)
#include <c64.h>
#include <string.h>
#include "font-hex.c"

byte* SCREEN = (byte*)0x0400;
byte* CHARSET = (byte*)0x2000;

void main() {
    *D018 = toD018(SCREEN, CHARSET);
    init_font_hex(CHARSET);
    // Show all chars on screen
    for (byte c: 0..255) {
        SCREEN[c] = c;
    }
}

