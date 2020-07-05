// A full-screen x/y-scroller
// The main screen is double-buffered with a shared charset. Most of the screen is expected to be empty (filled with char 0)
// While scrolling through the pixels on one screen the second screen is prepared. When needed a swap is made.
// At any time an object is being scrolled onto the screen. The object is fetched from an 8x8 char buffer.
//
// The scroll director orchestrates the movement of the main screen, rendering on the second screen from the buffer and the rendering of graphics in the buffer. 
// In practice the scroll director calculates a number of frames ahead to identify the operations needed on each frame. It calculates ahead until it encounters the next "new buffer needed".

#include <c64.h>
#include <string.h>
#include <conio.h>
#include <stdio.h>

// Dispaly screen #1 (double buffered)
char * const MAIN_SCREEN1 = 0x0400;
// Display screen #2 (double buffered)
char * const MAIN_SCREEN2 = 0x3800;
// Display charset
char * const MAIN_CHARSET = 0x1000;

// The render 8x8 buffer containing chars to be rendered onto the screen
char RENDER_BUFFER[8*8] =
    "   **   "
    " ****** "
    " ****** "
    "********"
    "********"
    " ****** "
    " ****** "
    "   **   "z
;

void main() {
    VICII->MEMORY = toD018(MAIN_SCREEN1, MAIN_CHARSET);
    memset(MAIN_SCREEN1, ' ', 1000);
    
    // positions to render to
    char xpos=0, ypos=0;
    while(xpos < 40 && ypos < 25) {
        char *sc = MAIN_SCREEN1 + (unsigned int)ypos*40 + xpos;
        char i=0;
        for(char y=0; y<8; y++) {
            for(char x=0; x<8; x++) {
                char c=RENDER_BUFFER[i++];
                if(c!=' ' && xpos+x<40 && ypos+y<25)
                    sc[x] = c;
            }
            sc+=40;
        }
        xpos+=5;
        ypos+=3;
    }

    // count the number of chars
    unsigned int count = 0;
    for(char *sc = MAIN_SCREEN1;sc<MAIN_SCREEN1+1000;sc++)
        if(*sc!=' ') count++;
    gotoxy(0,0);
    printf("%u",count);

}




