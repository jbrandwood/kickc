#include <c64.h>
#include <bitmap-draw.h>

char* const SCREEN = $400;
char* const BITMAP = $2000;

char lines_x[] = { 60, 80, 110, 80, 60, 40, 10, 40, 60 };
char lines_y[] = { 10, 40, 60, 80, 110, 80, 60, 40, 10 };
char lines_cnt = 8;

void main() {
    *BORDERCOL = 0;
    *BGCOL = 0;
    *D011 = VIC_BMM|VIC_DEN|VIC_RSEL|3;
    *VIC_MEMORY =  (char)((((unsigned int)SCREEN&$3fff)/$40)|(((unsigned int)BITMAP&$3fff)/$400));
    bitmap_init(BITMAP);
    bitmap_clear();
    init_screen();
    do {
        lines();
    } while (true);
}

void lines() {
    for(char l=0; l<lines_cnt;l++) {
        bitmap_line(lines_x[l], lines_x[l+1], lines_y[l], lines_y[l+1]);
    }
}

void init_screen() {
    for(char* c = SCREEN; c!=SCREEN+$400;c++) {
        *c = $14;
    }
}
