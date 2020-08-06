// Hello World for Atari XL / XE
// XEX file format https://www.atarimax.com/jindroush.atari.org/afmtexe.html
// Minimal Hello World https://atariage.com/forums/topic/229742-help-with-hello-world-in-mads/
// Display Lists atariarchives.org/mapping/appendix8.php

#pragma target(atarixl)

// Direct Memory Access Control
// 7 6 5 4 3 2 1 0
// - - - - - - 0 0 No playfield
// - - - - - - 0 1 Narrow playfield (128 color clocks	32 characters)
// - - - - - - 1 0 Standard playfield (160 color clocks	40 characters) (default)
// - - - - - - 1 1 Wide playfield (192 color clocks	48 characters)
// - - - - - 1 - - Enable missle DMA
// - - - - 1 - - - Enable player DMA
// - - - 1 - - - - One line player resolution
// - - - 0 - - - - Two-line player resolution (default)
// - - 1 - - - - - Enable DMA for fetching the display list instructions (default)
// SHADOW: SDMCTL $022F
char * const ANTIC_DMACTL = 0xd400;

// OS Shadow ANTIC Direct Memory Access Control
char * const SDMCTL = 0x022f;

// Character Control
// 7 6 5 4 3 2 1 0
// - - - - - - - 1 Video Blank. Inverse video characters display as blanks spaces.
// - - - - - - 1 - Video Inverse. Inverse video characters appear as inverse video. (default)
// - - - - - 1 - - Video Reflect. All characters are displayed vertically mirrored.
// SHADOW: CHART $02F3
char * const ANTIC_CHACTL = 0xd401;

// OS Shadow ANTIC Character Control
char * const CHART = 0x02f3;

// Display List Pointer
// ANTIC begins executing the Display List pointed to by the 16-bit address in registers DLISTL/DLISTH
// SHADOW: SDLSTL/SDLSTH $0230/$0231
char ** const ANTIC_DLIST = 0xd402;

// OS Shadow ANTIC Display List Pointer
char ** const SDLST = 0x0230;

void main() {
    // Enable DMA, Narrow Playfield into Shadow ANTIC Direct Memory Access Control
    *SDMCTL = 0x21; 
    // Set Shadow ANTIC Display List Pointer
    *SDLST = DISPLAY_LIST;
    // Loop forever
    while (1) ;
}

// Message to show
// Encoding: atari_internal
char TEXT[] = {'h'|0x20,'e'|0x20,'l'|0x20,'l'|0x20,'o'|0x20,0x0,'x'|0x60,'t'|0x60,0x0,'w'|0x20,'o'|0x20,'r'|0x20,'l'|0x20,'d'|0x20,0x41,0x0,0x0,0x0,0x0};

// ANTIC Display List Program
// https://en.wikipedia.org/wiki/ANTIC
char DISPLAY_LIST[] = {
   0x70, 0x70, 0x70,                    // 3* BLK 8             (0x70) 8 blank lines 
   0x47, <TEXT, >TEXT,                  //    LMS 7, TEXT       (0x47)  Load memory address and set to charmode 7 (16/20/24 chars wide, 16 lines per char)
   0x41, <DISPLAY_LIST, >DISPLAY_LIST   //    JVB DISPLAY_LIST  (0x41) jump and wait for VBLANK
};

