// A KickC version of the plasma routine from the CC65 samples
// This version has an unrolled inner loop to reach 50+FPS
// This version also optimizes the inner loop by calculating the Y buffer as a set of differences
// (w)2001 by groepaz/hitmen
// Cleanup and porting to CC65 by Ullrich von Bassewitz.
// Ported to KickC by Jesper Gravgaard.
// Original source https://github.com/cc65/cc65/blob/master/samples/plasma.c

#include <c64.h>
#include <c64-print.h>

unsigned char* const SCREEN1 = (char*)$2800;
unsigned char* const CHARSET = (char*)$2000;

const unsigned char __align(0x100) SINTABLE[0x100] = kickasm {{
    .for(var i=0;i<$100;i++)
        .byte round(127.5+127.5*sin(toRadians(360*i/256)))
}};

void main() {
    asm { sei }
    VICII->BORDER_COLOR = BLUE;
    VICII->BG_COLOR = BLUE;
    for(unsigned char* col : COLS..COLS+1000) *col = BLACK;
    makecharset(CHARSET);
    *D018 = toD018(SCREEN1, CHARSET);
    while(true) {
        // Show single-buffered plasma
        doplasma(SCREEN1);
    }
}

// Plasma state variables
unsigned char c1A = 0;
unsigned char c1B = 0;
unsigned char c2A = 0;
unsigned char c2B = 0;

// Render plasma to the passed screen
void doplasma(unsigned char* screen) {

    unsigned char xbuf[40];
    unsigned char ybuf[25];

    unsigned char c1a = c1A;
    unsigned char c1b = c1B;
    unsigned char yprev = 0;
    // Calculate ybuff as a bunch of differences
    for (unsigned char i = 0; i < 25; ++i) {
        unsigned char yval = (SINTABLE[c1a] + SINTABLE[c1b]);
        ybuf[i] = yval - yprev;
        yprev = yval;
        c1a += 4;
        c1b += 9;
    }
    c1A += 3;
    c1B -= 5;
    unsigned char c2a = c2A;
    unsigned char c2b = c2B;
    for (unsigned char i = 0; i < 40; ++i) {
        xbuf[i] = (SINTABLE[c2a] + SINTABLE[c2b]);
        c2a += 3;
        c2b += 7;
    }
    c2A += 2;
    c2B -= 3;
    for (unsigned char i = 0; i < 40; ++i) {
        // Find the first value on the row
        unsigned char val =  xbuf[i];
        // Calculate the next values as sums of diffs
        // Use experimental loop unrolling to increase the speed
        inline for (unsigned char ii = 0; ii < 25; ++ii) {
            val += ybuf[ii];
            (screen+ii*40)[i] = val;
        }
    }
}

// Make a plasma-friendly charset where the chars are randomly filled
void makecharset(unsigned char* charset) {
    const unsigned char bittab[8] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };
    sid_rnd_init();
    print_cls();
    for (unsigned int c = 0; c < 0x100; ++c) {
        unsigned char s = SINTABLE[BYTE0(c)];
        for ( unsigned char i = 0; i < 8; ++i){
            unsigned char b = 0;
            for (unsigned char ii = 0; ii < 8; ++ii) {
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
