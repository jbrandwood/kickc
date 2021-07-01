// Find atan2(x, y) using the CORDIC method
// See http://bsvi.ru/uploads/CORDIC--_10EBA/cordic.pdf

#include "font-hex.c"
#include <atan2.h>
#include <c64.h>

byte* const CHARSET = (byte*)0x2000;
byte* const SCREEN = (byte*)0x2800;

void main() {
    init_font_hex(CHARSET);
    *D018 = toD018(SCREEN, CHARSET);
    byte* screen = SCREEN;
    for(signed byte y: -12..12) {
        for(signed byte x: -19..20) {
            signed word xw = (signed word)MAKEWORD( (byte)x, 0 );
            signed word yw = (signed word)MAKEWORD( (byte)y, 0 );
            word angle_w = atan2_16(xw, yw);
            byte ang_w = BYTE1(angle_w+0x0080);
            *screen++ = ang_w;
        }
    }
    byte* col00 = COLS+12*40+19;
    while(true) (*col00)++;
}
