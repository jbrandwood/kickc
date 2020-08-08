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
char TEXT[] = "hello XT world! ";

// ANTIC Display List Program
// https://en.wikipedia.org/wiki/ANTIC
char DISPLAY_LIST[] = {
   0x70, 0x70, 0x70,                    // 3* BLK 8             (0x70) 8 blank lines 
   0x47, <TEXT, >TEXT,                  //    LMS 7, TEXT       (0x47) Load memory address and set to charmode 7 (16/20/24 chars wide, 16 lines per char)
   0x41, <DISPLAY_LIST, >DISPLAY_LIST   //    JVB DISPLAY_LIST  (0x41) jump and wait for VBLANK
};

