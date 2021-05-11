// Illustrates problem with bitmap-draw.kc line()
// Reported by Janne Johansson

#include <c64.h>
#include <c64-bitmap.h>

byte* const SCREEN = (byte*)$400;
byte* const BITMAP = (byte*)$2000;

byte next=0;

void main() {
    *BORDER_COLOR = 0;
    *BG_COLOR = 0;
    *D011 = VICII_BMM|VICII_DEN|VICII_RSEL|3;
    *VICII_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)BITMAP&$3fff)/$400));
    bitmap_init(BITMAP, SCREEN);
    bitmap_clear(BLACK, WHITE);
    init_screen();
    do {
      bitmap_line(0,0,next,100);
      next++;
    } while (true);
}

void init_screen() {
    for(byte* c = SCREEN; c!=SCREEN+$400;c++) {
        *c = $14;
    }
}
