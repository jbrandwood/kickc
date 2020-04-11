// Find atan2(x, y) using the CORDIC method
// See http://bsvi.ru/uploads/CORDIC--_10EBA/cordic.pdf
#include "font-hex.c"
#include <atan2.c>
#include <c64.c>

byte* const CHARSET = 0x2000;
byte* const SCREEN = 0x2800;

void main() {
    init_font_hex(CHARSET);
    *D018 = toD018(SCREEN, CHARSET);
    init_angle_screen(SCREEN);

    // Clear the screen by modifying the charset
    byte* clear_char = CHARSET;
    while(true) {
        do {} while(*RASTER!=0xff);
        if(clear_char<CHARSET+0x0800) {
            *clear_char++ = 0;
        }
    }
}

// Populates 1000 bytes (a screen) with values representing the angle to the center.
// Utilizes symmetry around the  center
void init_angle_screen(byte* screen) {
    byte* screen_topline = screen+40*12;
    byte *screen_bottomline = screen+40*12;
    for(byte y: 0..12) {
        for( byte x=0,xb=39; x<=19; x++, xb--) {
            signed word xw = (signed word)(word){ 39-x*2, 0 };
            signed word yw = (signed word)(word){ y*2, 0 };
            word angle_w = atan2_16(xw, yw);
            byte ang_w = >(angle_w+0x0080);
            screen_topline[x] = 0x80+ang_w;
            screen_bottomline[x] = 0x80-ang_w;
            screen_topline[xb] = -ang_w;
            screen_bottomline[xb] = ang_w;
        }
        screen_topline -= 40;
        screen_bottomline += 40;
    }
}