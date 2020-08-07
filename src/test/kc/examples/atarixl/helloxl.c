// Hello World for Atari XL / XE
// XEX file format https://www.atarimax.com/jindroush.atari.org/afmtexe.html
// Minimal Hello World https://atariage.com/forums/topic/229742-help-with-hello-world-in-mads/
// Display Lists atariarchives.org/mapping/appendix8.php

#pragma target(atarixl)
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
// Encoding: atari_screencode
char TEXT[] = {'h'|0x20,'e'|0x20,'l'|0x20,'l'|0x20,'o'|0x20,0x0,'x'|0x60,'t'|0x60,0x0,'w'|0x20,'o'|0x20,'r'|0x20,'l'|0x20,'d'|0x20,0x41,0x0,0x0,0x0,0x0};

// ANTIC Display List Program
// https://en.wikipedia.org/wiki/ANTIC
char DISPLAY_LIST[] = {
   0x70, 0x70, 0x70,                    // 3* BLK 8             (0x70) 8 blank lines 
   0x47, <TEXT, >TEXT,                  //    LMS 7, TEXT       (0x47)  Load memory address and set to charmode 7 (16/20/24 chars wide, 16 lines per char)
   0x41, <DISPLAY_LIST, >DISPLAY_LIST   //    JVB DISPLAY_LIST  (0x41) jump and wait for VBLANK
};

