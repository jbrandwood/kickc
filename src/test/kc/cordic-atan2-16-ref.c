// Find atan2(x, y) using the CORDIC method
// See http://bsvi.ru/uploads/CORDIC--_10EBA/cordic.pdf

#include "font-hex.c"
#include <atan2.h>
#include <c64.h>
#include <c64-print.h>

byte* const CHARSET = (byte*)0x2000;
byte* const SCREEN = (byte*)0x2800;

const byte SCREEN_REF[1000] = kickasm {{
    .for(var y=-12;y<=12;y++)
        .for(var x=-19;x<=20;x++)
            .byte round(256*atan2(y, x)/PI/2)
}};

void main() {
    init_font_hex(CHARSET);
    *D018 = toD018(SCREEN, CHARSET);
    byte* screen = SCREEN;
    byte* screen_ref = SCREEN_REF;
    word diff_sum = 0;
    for(signed byte y: -12..12) {
        for(signed byte x: -19..20) {
            //byte angle_b = atan2_8(x, y);
            //diff_sum += diff(angle_b, *screen_ref);
            //*screen = angle_b - *screen_ref++;
            //*screen = angle_b;
            signed word xw = (signed word)MAKEWORD( (byte)x, 0 );
            signed word yw = (signed word)MAKEWORD( (byte)y, 0 );
            word angle_w = atan2_16(xw, yw);
            byte ang_w = BYTE1(angle_w+0x0080);
            //*screen = (>angle_w)-angle_b;
            //*screen = >angle_w;
            diff_sum += diff(ang_w, *screen_ref);
            *screen =  ang_w - *screen_ref;
            //*screen++ = *screen_ref++;

            screen++;
            screen_ref++;
        }
    }
    print_uint(diff_sum);
    byte* col00 = COLS+12*40+19;
    while(true) (*col00)++;
}

byte diff(byte bb1, byte bb2) {
    return (bb1<bb2)?(bb2-bb1):bb1-bb2;
}

