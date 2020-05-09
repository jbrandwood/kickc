// Random walk with color fading for Commodore Plus/4 / C16
#pragma link("plus4.ld")
#pragma emulator("xplus4")

#include <string.h>
#include <stdlib.h>

char * const SCREEN = 0x0c00;
char * const COLORRAM = 0x0800;

char * const BGCOLOR = 0xff19;
char * const BORDERCOLOR = 0xff15;
char * const RASTER = 0xff1d;

char FADE[16] = { 0x02, 0x12, 0x22, 0x32, 0x42, 0x52, 0x62, 0x72, 0x76, 0x66, 0x56, 0x46, 0x36, 0x26, 0x16, 0x06 };
char COUNT[1000];

void main() {
    memset(SCREEN, 0xa0, 1000);
    memset(COLORRAM, 0, 1000);
    memset(COUNT, 0, 1000);
    *BORDERCOLOR = 0;
    *BGCOLOR = 0;
    char x=20, y=12;
    while(1) {
        unsigned int offset = (unsigned int)y*40+x;
        char cnt = ++*(COUNT+offset);
        *(COLORRAM+offset) = FADE[cnt&0xf];
        char rnd = >rand();
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
        while(*RASTER!=0xff) {}    
    }
}