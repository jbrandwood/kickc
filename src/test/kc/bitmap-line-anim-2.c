// Shows that bitmap2.kc line() does not have the same problem as bitmap-draw.kc
// See bitmap-line-anim-1.kc

#include <c64.c>
#include <bitmap2.c>

byte* const SCREEN = $400;
byte* const BITMAP = $2000;

word next=0;

void main() {
    *BORDERCOL = 0;
    *BGCOL = 0;
    *D011 = VIC_BMM|VIC_DEN|VIC_RSEL|3;
    *VIC_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)BITMAP&$3fff)/$400));
    bitmap_init(BITMAP, SCREEN);
    bitmap_clear(PURPLE, WHITE);
    do {
      bitmap_line(0,0,next,100);
      next++;
      if(next==320) next=0;
    } while (true);
}
