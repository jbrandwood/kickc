// A KickC version of the fire routine from the CC65 samples
// (w)2002 by groepaz/hitmen
// Cleanup and porting to CC65 by Ullrich von Bassewitz and Greg King .
// Ported to KickC by Jesper Gravgaard.
// Original source https://github.com/cc65/cc65/blob/master/samples/fire.c

#include <c64.h>

unsigned char* SCREEN1 = (unsigned char*)0x3800;
unsigned char* SCREEN2 = (unsigned char*)0x3c00;
unsigned char* BUFFER = (unsigned char*)0x4000;
unsigned char* CHARSET = (unsigned char*)0x3000;

void main() {
    asm { sei }
    VICII->BORDER_COLOR = BLACK;
    VICII->BG_COLOR = BLACK;
    fillscreen(BUFFER, 00);
    fillscreen(SCREEN1, 00);
    fillscreen(SCREEN2, 00);
    fillscreen(COLS, YELLOW);
    sid_rnd_init();
    makecharset(CHARSET);
    // Show double-buffered fire
    while(true) {
        fire(SCREEN1);
        *D018 = toD018(SCREEN1, CHARSET);
        fire(SCREEN2);
        *D018 = toD018(SCREEN2, CHARSET);
    }
}

// Animate the fire on the passed screen. Uses BUFFER to store the current values.
void fire(unsigned char* screenbase) {

    // Average characters from below the current character (24 lines)
    unsigned char* screen = screenbase;
    unsigned char* buffer = BUFFER;
    while (buffer != (BUFFER + (24 * 40))) {
        unsigned char c = ( buffer[40-1] + buffer[40-1] + buffer[40] + buffer[41] )/4;
        if (c > 2) {
            c -= 3;
        }
        *screen = *buffer = c;
        ++screen;
        ++buffer;
    }
    // Add one new random line at the bottom
    screen = (screenbase + (24 * 40));
    buffer = (BUFFER + (24 * 40));
    for(; buffer != (BUFFER+(25*40)); ++screen, ++buffer) {
        *screen = *buffer = 0x30 + (sid_rnd())/$10;
    }
}

// Make a fire-friendly charset in chars $00-$3f of the passed charset
void makecharset(char* charset) {
    const unsigned char bittab[8] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };
    for (unsigned char *font = charset; font != (charset+(1*8)); ++font)
        *font = 0x00;
    for (unsigned char *font = (charset+(64*8)); font != (charset+(256*8)); ++font)
        *font = 0xff;
    for (unsigned char c = 0; c < 0x40; ++c) {
        for (unsigned char bc = 0, i = 0; i < 8; i++){
            unsigned char b = 0;
            for (unsigned char ii = 0; ii < 8; ii++) {
                bc += c;
                if (bc > 0x3f) {
                    bc = bc - 0x40;
                    b += bittab[(ii + (i & 1)) & 0x7];
                }
            }
            (charset + (1 * 8)) [(((unsigned short)c) << 3) + i] = b;
        }
    }
}

// Fill a screen (1000 chars) with a specific char
void fillscreen(unsigned char* screen, unsigned char fill) {
    for( unsigned int i : 0..999) {
        *screen++ = fill;
    }
}
