// Plasma based on the distance/angle to the screen center

#include <c64.h>
#include <stdlib.h>
#include <string.h>
#include <sqr.h>
#include <atan2.h>
#include <c64-print.h>

const char __align(0x100) SINTABLE[0x200] = kickasm {{
    .for(var i=0;i<$200;i++)
        .byte round(127.5+127.5*sin(2*PI*i/256))
}};

// Screen containing distance to center
byte* SCREEN_DIST = malloc(1000);
// Screen containing angle to center
byte* SCREEN_ANGLE = malloc(1000);
// Plasma charset
char* const CHARSET = (char*)0x2000;
// Plasma screen 1
char* const SCREEN1 = (char*)0x2800;
// Plasma screen 2
char* const SCREEN2 = (char*)0x2c00;

void main() {
    init_dist_screen(SCREEN_DIST);
    init_angle_screen(SCREEN_ANGLE);
    make_plasma_charset(CHARSET);
    memset(COLS, BLACK, 1000);
    // Show double-buffered plasma
    while(true) {
        doplasma(SCREEN1);
        *D018 = toD018(SCREEN1, CHARSET);
        doplasma(SCREEN2);
        *D018 = toD018(SCREEN2, CHARSET);
    }
}

// Offsets for the sines
byte sin_offset_x = 0;
byte sin_offset_y = 0;

// Render plasma to the passed screen
void doplasma (char* screen) {
    char* angle = SCREEN_ANGLE;
    char* dist = SCREEN_DIST;
    byte* sin_x = SINTABLE+sin_offset_x;
    byte* sin_y = SINTABLE+sin_offset_y;
    for( char y: 0..25) {
        for( char x: 0..39) {
            screen[x] = sin_x[angle[x]] + sin_y[dist[x]];
        }
        screen += 40;
        angle += 40;
        dist += 40;
    }
    sin_offset_x -= 3;
    sin_offset_y -= 7;
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

// Make a plasma-friendly charset where the chars are randomly filled
void make_plasma_charset(char* charset) {
    const char bittab[8] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };
    sid_rnd_init();
    print_cls();
    for (unsigned int c = 0; c < 0x100; ++c) {
        char s = SINTABLE[BYTE0(c)];
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