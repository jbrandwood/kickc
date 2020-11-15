// Hello World for Atari XL / XE
// XEX file format https://www.atarimax.com/jindroush.atari.org/afmtexe.html
// Minimal Hello World https://atariage.com/forums/topic/229742-help-with-hello-world-in-mads/
// Display Lists atariarchives.org/mapping/appendix8.php

#pragma target(atarixl)
#pragma encoding(screencode_atari)
#include <atari-xl.h>

void main() {
    // Enable DMA, Narrow Playfield into Shadow ANTIC Direct Memory Access Control
    *SDMCTL = 0x21; 
    // Set Shadow ANTIC Display List Pointer
    *SDLST = DISPLAY_LIST;
    // Loop forever
    while (1) ;
}

// Message to show
char TEXT[] = "HELLO atari 8BIT"
              "Demonstrates ANTIC display list"
            ;

// ANTIC Display List Program
// https://en.wikipedia.org/wiki/ANTIC
char DISPLAY_LIST[] = {
   BLANK8, BLANK8, BLANK8,              // 3* 8 blank lines
   LMS|MODE7, <TEXT, >TEXT,             // Load memory address and set to charmode 7 (16/20/24 chars wide, 16 lines per char)
   BLANK4,                              // 4 blank lines
   MODE2,                               // Charmode 2 (32/40/48 chars wide, 8 lines per char)
   JVB, <DISPLAY_LIST, >DISPLAY_LIST    // Wait for VBLANK snd jump
};
