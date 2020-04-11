// Find atan2(x, y) using the CORDIC method
// See http://bsvi.ru/uploads/CORDIC--_10EBA/cordic.pdf

#include "font-hex.c"
#include <c64.h>
#include <atan2.h>


byte* const CHARSET = 0x2000;
byte* const SCREEN = 0x2800;

void main() {
    init_font_hex(CHARSET);
    *D018 = toD018(SCREEN, CHARSET);
    byte* screen = SCREEN;
    for(signed byte y: -12..12) {
        for(signed byte x: -19..20) {
            byte angle = atan2_8(x, y);
            *screen++ = angle;
        }
    }

    byte* col00 = COLS+12*40+19;
    while(true) (*col00)++;

}

