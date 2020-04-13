// Calculate the distance to the center of the screen - and show it using font-hex

#include <stdlib.h>
#include <sqr.h>
#include <c64.h>
#include "font-hex.c"
#include <time.h>
#include <print.h>

#pragma reserve(08)

byte* const CHARSET = 0x2000;
byte* const SCREEN = 0x2800;

void main() {
    init_font_hex(CHARSET);
    *D018 = toD018(SCREEN, CHARSET);
    clock_start();
    init_dist_screen(SCREEN);
    clock_t cyclecount = clock()-CLOCKS_PER_INIT;
    byte* BASE_SCREEN = 0x0400;
    byte* BASE_CHARSET = 0x1000;
    print_ulong_at(cyclecount, BASE_SCREEN);
    *D018 = toD018(BASE_SCREEN, BASE_CHARSET);
}

// Populates 1000 bytes (a screen) with values representing the distance to the center.
// The actual value stored is distance*2 to increase precision
void init_dist_screen(byte* screen) {
    NUM_SQUARES = 0x30;
    init_squares();
    byte* screen_topline = screen;
    byte *screen_bottomline = screen+40*24;
    for(byte y: 0..12) {
        byte y2 = y*2;
        byte yd = (y2>=24)?(y2-24):(24-y2);
        word yds = sqr(yd);
        for( byte x=0,xb=39; x<=19; x++, xb--) {
            byte x2 = x*2;
            byte xd = (x2>=39)?(x2-39):(39-x2);
            word xds = sqr(xd);
            word ds = xds+yds;
            byte d = sqrt(ds);
            screen_topline[x] = d;
            screen_bottomline[x] = d;
            screen_topline[xb] = d;
            screen_bottomline[xb] = d;
        }
        screen_topline += 40;
        screen_bottomline -= 40;
    }
}