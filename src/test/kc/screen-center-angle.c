// Calculate the angle to the center of the screen - and show it using font-hex
// 4.65 million cycles
#include <stdlib.h>
#include <c64.h>
#include "font-hex.c"
#include <atan2.h>
#include <c64-time.h>
#include <c64-print.h>

byte* const CHARSET = (byte*)0x2000;
byte* const SCREEN = (byte*)0x2800;

void main() {
    init_font_hex(CHARSET);
    *D018 = toD018(SCREEN, CHARSET);

    clock_start();
    init_angle_screen(SCREEN);
    clock_t cyclecount = clock()-CLOCKS_PER_INIT;
    byte* BASE_SCREEN = (byte*)0x0400;
    byte* BASE_CHARSET = (byte*)0x1000;
    print_ulong_at(cyclecount, BASE_SCREEN);
    *D018 = toD018(BASE_SCREEN, BASE_CHARSET);
}

// Populates 1000 bytes (a screen) with values representing the angle to the center.
// Utilizes symmetry around the  center
void init_angle_screen(byte* screen) {
    byte* screen_topline = screen+40*12;
    byte *screen_bottomline = screen+40*12;
    for(byte y: 0..12) {
        for( byte x=0,xb=39; x<=19; x++, xb--) {
            signed word xw = (signed word)MAKEWORD( 39-x*2, 0 );
            signed word yw = (signed word)MAKEWORD( y*2, 0 );
            word angle_w = atan2_16(xw, yw);
            byte ang_w = BYTE1(angle_w+0x0080);
            screen_bottomline[xb] = ang_w;
            screen_topline[xb] = -ang_w;
            screen_topline[x] = 0x80+ang_w;
            screen_bottomline[x] = 0x80-ang_w;
        }
        screen_topline -= 40;
        screen_bottomline += 40;
    }
}