// Tests the simple bitmap plotter
// Plots a few lines using the bresenham line algorithm
#include <c64.h>
#include <bitmap2.h>
#include <print.h>

byte* BITMAP = 0x2000;
byte* SCREEN = 0x0400;

byte __align(0x100) SINTAB[0x180] = kickasm {{ .fill $180, 99.5+99.5*sin(i*2*PI/256) }};
byte* COSTAB = SINTAB+0x40;

void main() {
    bitmap_init(BITMAP, SCREEN);
    bitmap_clear(BLACK, WHITE);
    *D011 = VICII_BMM|VICII_DEN|VICII_RSEL|3;
    *D018 = toD018(SCREEN, BITMAP);
    for( byte i=0, a=0; i!=8; i++, a+=32) {
        bitmap_line( (word)COSTAB[a]+120, (word)SINTAB[a], (word)COSTAB[a+32]+120, (word)SINTAB[a+32]);
    }
    while(true)
        (*(SCREEN+999))++;
}
