// A KickC version of the plasma routine from the CC65 samples
// (w)2001 by groepaz/hitmen
// Cleanup and porting to CC65 by Ullrich von Bassewitz.
// Ported to KickC by Jesper Gravgaard.
// Original source https://github.com/cc65/cc65/blob/master/samples/plasma.c

#include <c64.h>
#include <print.h>
#include "sid.c"

char* const SCREEN1 = 0x2800;
char* const SCREEN2 = 0x2c00;
char* const CHARSET = 0x2000;

const char align(0x100) SINTABLE[0x100] = kickasm {{
    .for(var i=0;i<$100;i++)
        .byte round(127.5+127.5*sin(2*PI*i/256))
}};

void main() {
    asm { sei }
    *BORDERCOL = BLUE;
    *BGCOL = BLUE;
    for(char* col : COLS..COLS+1000) *col = BLACK;
    makecharset(CHARSET);
    // Show double-buffered plasma
    while(true) {
        doplasma(SCREEN1);
        *D018 = toD018(SCREEN1, CHARSET);
        doplasma(SCREEN2);
        *D018 = toD018(SCREEN2, CHARSET);
    }
}

// Plasma state variables
char c1A = 0;
char c1B = 0;
char c2A = 0;
char c2B = 0;

// Render plasma to the passed screen
void doplasma (char* screen) {

    char xbuf[40];
    char ybuf[25];

    char c1a = c1A;
    char c1b = c1B;
    for (char i = 0; i < 25; ++i) {
        ybuf[i] = (SINTABLE[c1a] + SINTABLE[c1b]);
        c1a += 4;
        c1b += 9;
    }
    c1A += 3;
    c1B -= 5;
    char c2a = c2A;
    char c2b = c2B;
    for (char i = 0; i < 40; ++i) {
        xbuf[i] = (SINTABLE[c2a] + SINTABLE[c2b]);
        c2a += 3;
        c2b += 7;
    }
    c2A += 2;
    c2B -= 3;
    for (char ii = 0; ii < 25; ++ii) {
        for (char i = 0; i < 40; ++i) {
            screen[i] = (xbuf[i] + ybuf[ii]);
        }
        screen += 40;
    }
}

// Make a plasma-friendly charset where the chars are randomly filled
void makecharset(char* charset) {
    const char bittab[8] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };
    sid_rnd_init();
    print_cls();
    for (unsigned int c = 0; c < 0x100; ++c) {
        char s = SINTABLE[<c];
        for ( char i = 0; i < 8; ++i){
            char b = 0;
            for (char ii = 0; ii < 8; ++ii) {
                if ((sid_rnd() & 0xFF) > s) {
                    b |= bittab[ii];
                }
            }
            charset[(c*8) + i] = b;
        }
        if ((c & 0x07) == 0) {
            print_char('.');
        }
    }
}
