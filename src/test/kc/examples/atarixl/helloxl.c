// Hello World for Atari XL / XE
// XEX file format https://www.atarimax.com/jindroush.atari.org/afmtexe.html
// Minimal Hello World https://atariage.com/forums/topic/229742-help-with-hello-world-in-mads/
// Display Lists atariarchives.org/mapping/appendix8.php

#pragma target(atarixl)
#pragma emulator("65XEDebugger")
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
   BLANK8, BLANK8, BLANK8,                    // 3* BLK 8             (0x70) 8 blank lines
   LMS|MODE7, <TEXT, >TEXT,                  //    LMS TEXT 7        (0x47) Load memory address and set to charmode 7 (16/20/24 chars wide, 16 lines per char)
   BLANK8,                                //    BLK 8             (0x70) 8 blank lines
   MODE2,                                //    TEXT 2            (0x02) Charmode 2 (32/40/48 chars wide, 8 lines per char)
   JVB, <DISPLAY_LIST, >DISPLAY_LIST   //    JVB DISPLAY_LIST  (0x41) jump and wait for VBLANK
};
