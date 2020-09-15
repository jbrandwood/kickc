// Raster65 Demo Implementation in C 
// Based on RASTER65 assembler demo
// https://mega.scryptos.com/sharefolder/MEGA/MEGA65+filehost
// https://www.forum64.de/index.php?thread/104591-xemu-vic-iv-implementation-update/&postID=1560511#post1560511

#pragma target(mega65_c64)
#pragma emulator("/Users/jespergravgaard/c64/mega65/xemu-hernandp/build/bin/xmega65.native -prg")
#include <mega65.h>
#include <string.h>

// The screen address
char * const SCREEN = 0x0400;

// Logo y-position (char row on screen)
char const LOGO_Y = 3;
// Scroll y-position (char row on screen)
char const SCROLL_Y = 13;
// Greeting y-position (char row on screen)
char const GREET_Y = 20;

// Sinus Values 0-183
char SINUS[256] = kickasm {{
    .fill 256, 91.5 + 91.5*sin(i*2*PI/256)
}};

// Music at an absolute address
__address(0x0fc0) char SONG[] = kickasm(resource "DiscoZak_2SID_patched.prg") {{
    .import c64 "DiscoZak_2SID_patched.prg"
}};

// Pointer to the song init routine
void()* songInit = (void()*) SONG;
// Pointer to the song play routine
void()* songPlay = (void()*) SONG+3;

void main() {
    // Enable MEGA65 features
    VICIII->KEY = 0x47;   
    VICIII->KEY = 0x53;
    // Enable 48MHz fast mode
    VICIV->CONTROLB |= 0x40;
    VICIV->CONTROLC |= 0x40;
    // Initialize music
    asm { lda #0 }
    (*songInit)();
    // Clear screen 
    memset(SCREEN, ' ', 40*25);
    // Put MEGA logo on screen
    for( char i=0; i<sizeof(MEGA_LOGO); i++) {
        (SCREEN + LOGO_Y*40)[i] = MEGA_LOGO[i];
    }
    // Put dummy text up for scroll and greet
    for( char i=0;i<40;i++) {
        (SCREEN + SCROLL_Y*40)[i] = 'a';
        (SCREEN + GREET_Y*40)[i] = 'b';
    }
    // Set up 256 color palette
    char i=0; 
    do {
        PALETTE_RED[i] = PAL_RED[i];
        PALETTE_GREEN[i] = PAL_GREEN[i];
        PALETTE_BLUE[i] = PAL_BLUE[i];
    } while(++i!=0);
    // Set up raster interrupts C64 style
    asm { sei }
    // Disable CIA 1 Timer IRQ
    CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR;
    // Set raster line to 0x16
    VICII->RASTER = 0x16;
    VICII->CONTROL1 &= 0x7f;
    // Enable Raster Interrupt
    VICII->IRQ_ENABLE = IRQ_RASTER;
    // Set the IRQ routine
    *HARDWARE_IRQ = &irq1;
    // no kernal or BASIC rom visible
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
    // open sideborder
    VICIV->SIDBDRWD_LO = 1;
    // Enable IRQ
    asm { cli }
    // Loop forever
    for(;;) ;
}

// Sinus Position
volatile char sinpos;
// Zoom Position
volatile char zoomx;
// soft scroll position of text scrolly (0-7)
volatile char xpos = 7;
// The greeting currently being shown
volatile char greetnm;
// The number of greetings
const char GREETCOUNT = 16;
// The number of raster lines
const char NUMBERL = 0xd8;
// Moving Raster Bars
char rasters[NUMBERL];

// BIG INTERRUPT LOOP
interrupt(hardware_stack) void irq1() {
    // force NTSC every frame (hehe)
    VICIV->RASLINE0 |= 0x80;
    // Acknowledge the IRQ
    VICII->IRQ_STATUS = IRQ_RASTER;
    // reset x scroll
    VICII->CONTROL2 = 0;

    // y rasterline where scrolly starts
    const char scrollypos = 0x66;
    // size of raster behind scrolly
    const char blackbar = 19;

    // Generate Raster Bars and more
    char wobblepos = ++sinpos;
    for(char line=0;line!=NUMBERL;line++) {
        char col = rasters[line];
        VICIII->BORDER_COLOR = col;
        VICIII->BG_COLOR = col;
        if(line < scrollypos) {
            // if raster position < scrolly pos do wobble Logo!
            VICIV->TEXTXPOS_LO =  SINUS[wobblepos++];
            // No zooming
            VICIV->CHRXSCL = 0x66;
        } else if(line == scrollypos) {
            // if raster position = scrolly pos do scrolly
            // no wobbling from this point
            VICIV->TEXTXPOS_LO = 0x50;
            // set softscroll
            VICII->CONTROL2 = xpos;
        } else if(line == scrollypos+blackbar) {
            // if raster position > scrolly pos do nozoom
            // default value
            VICIV->TEXTXPOS_LO = 0x50;
        } else if(line == scrollypos+blackbar+1) {
            // if raster position > scrolly pos do zoom
            char zoomval = SINUS[zoomx++];
            VICIV->CHRXSCL = zoomval;
            VICIV->TEXTXPOS_LO = zoomval+1;
            if(zoomx==0) {
                // Advance greetings
                if(++greetnm==GREETCOUNT)
                    greetnm =0;
            }
        }
        // Wait for the next raster line
        char raster = VICII->RASTER;
        while(raster == VICII->RASTER) ;
    }

    // Show start of calculation
    VICII->BORDER_COLOR = 0x88;
    VICII->BG_COLOR = 0x88;

    // play music
    (*songPlay)();

    // Set up colors behind logo, scroll and greets
    char colsin = sinpos;
    for(char i=0;i<40;i++) {
        // Greeting colors
        char col = SINUS[colsin]/4;
        (COLORRAM + GREET_Y*40)[i] = col;
        // Logo colors
        col /= 2;
        (COLORRAM + LOGO_Y*40 + 0*40 - 1)[i] = col;
        (COLORRAM + LOGO_Y*40 + 1*40 - 2)[i] = col;
        (COLORRAM + LOGO_Y*40 + 2*40 - 3)[i] = col;
        (COLORRAM + LOGO_Y*40 + 3*40 - 4)[i] = col;
        (COLORRAM + LOGO_Y*40 + 4*40 - 5)[i] = col;
        (COLORRAM + LOGO_Y*40 + 5*40 - 6)[i] = col;
        // Scroll colors
        (COLORRAM + SCROLL_Y*40)[i] = PAL_GREEN[colsin];
        colsin++;
    }

    // Set all raster bars to black
    for(char l=0;l!=NUMBERL;l++) 
        rasters[l] = 0;        
    // Big block of bars (16)
    char barsin = sinpos;
    for(char barcnt=0; barcnt<16; barcnt++) {
        char idx = SINUS[barsin];
        char barcol = barcnt*16;
        for(char i=0;i<16;i++)
            rasters[idx++] = barcol++;
        for(char i=0;i<15;i++)
            rasters[idx++] = --barcol;
        barsin += 10;
    }
    // Produce dark area behind text
    for(char i=0;i<19;i++)
        rasters[scrollypos+i] = rasters[scrollypos+i] /2 & 7;

    // Show end of calculation
    VICII->BORDER_COLOR = 0;
    VICII->BG_COLOR = 0;

}

// A MEGA logo
char MEGA_LOGO[] = {  
    0x20,0x20,0x20,0x20,0x20,0xcf,0xcf,0xcf,0x20,0xcf,0xcf,0x20,0x20,0xcf,0xcf,0xcf,0x20,0x20,0xcf,0xcf,
    0xcf,0x20,0x20,0x20,0xcf,0xcf,0xcf,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
    0x20,0x20,0x20,0x20,0xcf,0xcf,0x20,0xcf,0xcf,0x20,0xcf,0x20,0xcf,0x20,0x20,0x20,0xcf,0xcf,0x20,0x20,
    0x20,0x20,0xcf,0xcf,0x20,0x20,0x20,0xcf,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
    0x20,0x20,0x20,0x20,0xcf,0xcf,0x20,0x20,0xcf,0x20,0xcf,0xcf,0xcf,0xcf,0xcf,0x20,0xcf,0xcf,0x20,0xcf,
    0xcf,0xcf,0xcf,0xcf,0x20,0x20,0x20,0xcf,0xcf,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,
    0x20,0x20,0x20,0x20,0xcf,0xcf,0xcf,0x20,0x20,0x20,0xcf,0xcf,0xcf,0x20,0x20,0x20,0x20,0xcf,0x20,0x20,
    0x20,0xcf,0xcf,0xcf,0x20,0xcf,0xcf,0xcf,0xcf,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,        
    0x20,0x20,0x20,0x20,0x20,0xcf,0x20,0x20,0x20,0x20,0xcf,0xcf,0x20,0xcf,0xcf,0xcf,0x20,0x20,0xcf,0xcf,
    0xcf,0x20,0x20,0xcf,0x20,0x20,0x20,0xcf
};

char PAL_RED[] = {
    0x00,0xf3,0xd4,0xb5,0xa6,0x97,0x88,0x79,0x1a,0xfa,0xeb,0xec,0xbd,0xbe,0xaf,0xff, 
    0x16,0xc6,0xa7,0x88,0x49,0x5a,0x2b,0x1c,0xac,0xad,0x8e,0x8f,0xff,0xff,0xff,0xff,
    0xc6,0x77,0x48,0x29,0xe9,0xfa,0xcb,0xcc,0x5d,0x4e,0x2f,0xff,0xff,0xff,0xff,0xff,
    0x57,0x18,0xf8,0xd9,0xaa,0x8b,0x6c,0x5d,0xed,0xde,0xcf,0xff,0xff,0xff,0xff,0xff,
    0x26,0xe6,0xb7,0xa8,0x69,0x5a,0x3b,0x3c,0xdc,0xcd,0xae,0x9f,0xff,0xff,0xff,0xff,
    0x65,0x16,0x17,0xf7,0xd8,0xb9,0x9a,0x8b,0x2c,0x0d,0xfd,0xee,0xcf,0xff,0xff,0xff,
    0x64,0x15,0x06,0xe6,0xc7,0xa8,0x99,0x8a,0x1b,0x0c,0xfc,0xfd,0xee,0xcf,0xff,0xff,
    0x12,0xd2,0xd3,0xb4,0x95,0x86,0x77,0x78,0x09,0x69,0xea,0xfb,0xdc,0xad,0xae,0xaf,
    0xf0,0xc1,0xc2,0xa3,0x84,0x85,0x76,0x67,0x08,0xf8,0xe9,0xda,0xdb,0xbc,0xbd,0xae,
    0x40,0x11,0x12,0xf2,0xe3,0xd4,0xc5,0xc6,0x47,0x38,0x39,0x2a,0x1b,0x0c,0x0d,0xed,
    0x00,0x00,0xf0,0xd1,0xc2,0xb3,0xa4,0x95,0x36,0x27,0x28,0x29,0xf9,0xea,0xeb,0xec,
    0x70,0x41,0x22,0x23,0xf3,0xf4,0xe5,0xe6,0x77,0x78,0x69,0x7a,0x3b,0x3c,0x3d,0x3e,
    0xa1,0x82,0x63,0x54,0x35,0x26,0x07,0x08,0x98,0x99,0x8a,0x7b,0x5c,0x5d,0x3e,0x3f,
    0x33,0x04,0xd4,0xd5,0xa6,0xa7,0x88,0x89,0x1a,0xab,0xfb,0xec,0xcd,0xbe,0xaf,0xff,
    0xb4,0x85,0x56,0x47,0x18,0x09,0xf9,0xea,0x7b,0x7c,0x5d,0x5e,0x2f,0xef,0xff,0xff,
    0x06,0xd6,0xa7,0x98,0x59,0x4a,0x2b,0x2c,0xbc,0xad,0x8e,0x8f,0xff,0xff,0xff,0xff
};

char PAL_GREEN[] = {
    0x00,0xe3,0xc4,0xb5,0x96,0x87,0x78,0x79,0x0a,0xfa,0xeb,0xdc,0xbd,0xae,0xaf,0xff, 
    0xe2,0xb3,0xa4,0x85,0x76,0x67,0x48,0x49,0xd9,0xda,0xbb,0xbc,0x8d,0x8e,0x7f,0xff,
    0x42,0x03,0x04,0xe4,0xd5,0xc6,0xb7,0xa8,0x39,0x3a,0x1b,0x2c,0xfc,0xfd,0xde,0xdf,
    0x61,0x32,0x13,0x04,0xe4,0xe5,0xd6,0xd7,0x78,0x59,0x4a,0x4b,0x2c,0x1d,0x0e,0xfe,
    0xe0,0xb1,0xa2,0x93,0x74,0x75,0x56,0x57,0xe7,0xd8,0x79,0xca,0xab,0x9c,0x9d,0x8e,
    0xf0,0xd1,0xc2,0xa3,0x84,0x85,0x76,0x77,0x08,0x09,0xf9,0xfa,0xdb,0xcc,0xbd,0xae,
    0x61,0x22,0x23,0x14,0xf4,0xe5,0xd6,0xc7,0x58,0x59,0x3a,0x3b,0x1c,0x0d,0xfd,0xfe,
    0x92,0x53,0x44,0x35,0x16,0xf6,0xe7,0xe8,0x79,0x6a,0x5b,0x4c,0x2d,0x3e,0x1f,0xef,
    0x53,0x14,0x05,0xe5,0xc6,0xb7,0xa8,0x99,0x2a,0x2b,0x0c,0x0d,0xdd,0xce,0xcf,0xff,
    0xf3,0xb4,0x95,0x86,0x57,0x38,0x29,0x1a,0xba,0xab,0x9c,0x8d,0x6e,0x5f,0xff,0xff,
    0x95,0x56,0x27,0x18,0xe8,0xd9,0xca,0xbb,0x4c,0x3d,0x2e,0x1f,0xef,0xff,0xff,0xff,
    0xc5,0x86,0x57,0x38,0x19,0x0a,0xea,0xdb,0x6c,0x5d,0x3e,0x3f,0xef,0xff,0xff,0xff,
    0x65,0x26,0x07,0xe7,0xc8,0xb9,0x9a,0x9b,0x2c,0x1d,0xfd,0xfe,0xcf,0xff,0xff,0xff,
    0xb4,0x75,0x56,0x37,0x28,0x19,0xe9,0xea,0x7b,0x6c,0x5d,0x4e,0x2f,0xff,0xff,0xff,
    0xc3,0x94,0x75,0x56,0x47,0x38,0x19,0x1a,0xaa,0xab,0x7c,0x7d,0x5e,0x4f,0xff,0xff,
    0xe2,0xa3,0x94,0x85,0x76,0x67,0x38,0x49,0xd9,0xca,0xab,0xbc,0x7d,0x7e,0x6f,0xff
};

char PAL_BLUE[] = {
    0x00,0xf3,0xd4,0xb5,0xa6,0x97,0x88,0x79,0x1a,0xfa,0xeb,0xec,0xbd,0xbe,0xaf,0xff, 
    0x00,0x00,0x00,0x00,0xc0,0xb1,0xa2,0xa3,0x34,0x35,0x26,0x27,0xf7,0xf8,0xf9,0xea,
    0x00,0x00,0x30,0x11,0x22,0x13,0x14,0x05,0xb5,0x96,0x97,0x98,0x79,0x6a,0x5b,0x4c,
    0x81,0x42,0x43,0x34,0x05,0x06,0xf6,0xf7,0x78,0x69,0x5a,0x5b,0x4c,0x3d,0x1e,0x0f,
    0x17,0xc7,0xa8,0x89,0x5a,0x5b,0x3c,0x1d,0xad,0x9e,0x7f,0xff,0xff,0xff,0xff,0xff,
    0x78,0x09,0xe9,0xca,0xab,0x7c,0x5d,0x5e,0xde,0xcf,0xff,0xff,0xff,0xff,0xff,0xff,
    0x59,0x0a,0xca,0xbb,0x8c,0x6d,0x3e,0x2f,0xbf,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
    0x49,0xf9,0xda,0xab,0x7c,0x5d,0x2e,0x2f,0xaf,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
    0x48,0xd8,0xb9,0xaa,0x7b,0x5c,0x2d,0x2e,0xbe,0x9f,0xff,0xff,0xff,0xff,0xff,0xff,
    0x07,0x97,0x88,0x69,0x4a,0x2b,0x1c,0x2d,0x9d,0x7e,0x6f,0xff,0xff,0xff,0xff,0xff,
    0x81,0x62,0x53,0x44,0x05,0x06,0xf6,0xe7,0x78,0x69,0x5a,0x5b,0x3c,0x2d,0x2e,0x1f,
    0x00,0x00,0x00,0x00,0xb0,0xb1,0xa2,0xb3,0x44,0x35,0x36,0x37,0x08,0xf8,0x0a,0x0b,
    0x00,0x00,0x00,0x00,0x00,0x70,0x61,0x62,0xf2,0xe3,0xd4,0xc5,0xb6,0xb7,0xb8,0x99,
    0x00,0x00,0x00,0x00,0x00,0x00,0xf0,0xf1,0x82,0x83,0x84,0x85,0x66,0x57,0x58,0x59,
    0x00,0x00,0x00,0x00,0x00,0x70,0x61,0x62,0xe2,0xe3,0xd4,0xd5,0xb6,0xa7,0xb8,0xa9,
    0x00,0x00,0x00,0x00,0xa0,0xb1,0xa2,0xa3,0x44,0x35,0x26,0x37,0xf7,0x19,0xf9,0xfa
};