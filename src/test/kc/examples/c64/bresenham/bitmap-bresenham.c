#include <c64.h>
#include <c64-bitmap.h>

char* const SCREEN = $400;
char* const BITMAP = $2000;

const char LINES = 8;
char lines_x[LINES+1] = { 60, 80, 110, 80, 60, 40, 10, 40, 60 };
char lines_y[LINES+1] = { 10, 40, 60, 80, 110, 80, 60, 40, 10 };

void main() {
    VICII->BORDER_COLOR = 0;
    VICII->BG_COLOR = 0;
    *D011 = VICII_BMM|VICII_DEN|VICII_RSEL|3;
    *VICII_MEMORY =  (char)((((unsigned int)SCREEN&$3fff)/$40)|(((unsigned int)BITMAP&$3fff)/$400));
    bitmap_init(BITMAP, SCREEN);
    bitmap_clear(BLACK, WHITE);
    init_screen();
    do {
        lines();
    } while (true);
}

void lines() {
    for(char l=0; l<LINES;l++) {
        bitmap_line(lines_x[l], lines_y[l], lines_x[l+1], lines_y[l+1]);
    }
}

void init_screen() {
    for(char* c = SCREEN; c!=SCREEN+$400;c++) {
        *c = $14;
    }
}
