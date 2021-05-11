#include <c64.h>

char* const SCREEN = (char*)$0400;
const char TEXT[] = "-= this is rex of camelot testing a scroller created in kickc. kickc is an optimizing c-compiler for 6502 assembler. =-     ";

void main() {
    fillscreen(SCREEN, $20);
    char scroll = 7;
    char* nxt = TEXT;
    char* const line = SCREEN+40;
    do {
        // Wait for raster
        do {} while(VICII->RASTER!=$fe);
        do {} while(VICII->RASTER!=$ff);
        ++VICII->BG_COLOR;
        // Soft scroll
        if(--scroll==$ff) {
            scroll = 7;
            // Hard scroll
            for(char i=0;i!=39;i++) {
                line[i]=line[i+1];
            }
            // Render next char
            char c = *nxt;
            if(c==0) {
               nxt = TEXT;
               c = *nxt;
            }
            line[39] = c;
            nxt++;
        }
        VICII->CONTROL2 = scroll;
        --VICII->BG_COLOR;
    } while(true);
}

void fillscreen(char* screen, char fill) {
    for( char* cursor = screen; cursor < screen+1000; cursor++) {
        *cursor = fill;
    }
}