// Illustrates problem with bitmap-draw.kc line()
// Reported by Janne Johansson

#include <c64.h>
#include <bitmap-draw.h>

byte* const SCREEN = $400;
byte* const BITMAP = $2000;

byte next=0;

void main() {
    *BORDER_COLOR = 0;
    *BG_COLOR = 0;
    *D011 = VICII_BMM|VICII_DEN|VICII_RSEL|3;
    *VICII_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)BITMAP&$3fff)/$400));
    bitmap_init(BITMAP);
    bitmap_clear();
    init_screen();
    do {
      bitmap_line(0,next,0,100);
      next++;
    } while (true);
}

void init_screen() {
    for(byte* c = SCREEN; c!=SCREEN+$400;c++) {
        *c = $14;
    }
}
