// Random walk with color fading for Commodore Plus/4 / C16
#pragma target(plus4)

#include <plus4.h>
#include <string.h>
#include <stdlib.h>

// Colors to fade up/down when visiting a char multiple times
char FADE[16] = { 0x02, 0x12, 0x22, 0x32, 0x42, 0x52, 0x62, 0x72, 0x76, 0x66, 0x56, 0x46, 0x36, 0x26, 0x16, 0x06 };

// The number of times each character has been visited
char VISITS[1000];

void main() {
    memset(DEFAULT_SCREEN, 0xa0, 1000);
    memset(DEFAULT_COLORRAM, 0, 1000);
    memset(VISITS, 0, 1000);
    TED->BG_COLOR = 0;
    TED->BORDER_COLOR = 0;
    char x=20, y=12;
    while(1) {
        unsigned int offset = (unsigned int)y*40+x;
        char cnt = ++*(VISITS+offset);
        *(DEFAULT_COLORRAM+offset) = FADE[cnt&0xf];
        char rnd = BYTE1(rand());
        if(rnd & 0x80) {
            if(rnd& 0x40) {
                x++;
                if(x==40) x=39;    
            } else {
                x--;
                if(x==0xff) x=0;    
        }
        } else {
            if(rnd & 0x40) {
                y++;
                if(y==25) y=24;    
            } else {
                y--;    
                if(y==0xff) y=0;
            }
        }
        while(TED->RASTER_LO!=0xff) {}
    }
    
}