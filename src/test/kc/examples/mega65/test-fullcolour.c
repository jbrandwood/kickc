// Test Full-Colour Graphics

#pragma target(mega65_remote)
#include <mega65.h>
#include <mega65-dma.h>
#include <6502.h>
#include <string.h>

// The screen address (40*25=0x03e8 bytes)
char * const SCREEN = 0x0400;
// The charset address (45*32*8=0x2d00 bytes)
char * const CHARSET = 0x2000;

void main() {
    // Avoid interrupts
    SEI();
    // Map memory to BANK 0 : 0x00XXXX - giving access to I/O
    memoryRemap(0,0,0);
    // Enable 48MHz fast mode
    VICIV->CONTROLB |= 0x40;
    VICIV->CONTROLC |= 0x40;
    // Enable the VIC 4
    VICIV->KEY = 0x47;
    VICIV->KEY = 0x53;
    // Enable Full-Colour Mode
    VICIV->CONTROLC |= 2;
    // Mode 40x25 chars 
    VICIV->CONTROLB &= 0x7f;
    VICIV->CHARSTEP_LO = 40;
    VICIV->CHARSTEP_HI = 0;
    // Set number of characters to display per row
    VICIV->CHRCOUNT = 40;
    // Set exact screen address
    VICIV->SCRNPTR_LOLO = <SCREEN;
    VICIV->SCRNPTR_LOHI = >SCREEN;
    VICIV->SCRNPTR_HILO = 0;
    VICIV->SCRNPTR_HIHI = 0;
    // Set exact charset address
    //VICIV->CHARPTR_LOLO = <CHARSET;
    //VICIV->CHARPTR_LOHI = >CHARSET;
    //VICIV->CHARPTR_HILO = 0;
    // Backgound color black
    VICIV->BG_COLOR = BLACK;

    // Put some colours into the palettes
    char c=0; do {
        PALETTE_RED[c] = c & 0x0f;
        PALETTE_GREEN[c] = 0x00;
        PALETTE_BLUE[c] = c / 0x10;

    } while (++c);

    // Fill the screen with 0x80 (char at 64*0x80 = 0x2000)
    memset_dma(SCREEN, 0x80, 40*25);
    // Fill the colours with WHITE - directly into $ff80000
    memset_dma256(0xff,0x08,0x0000, WHITE, 40*25);
    // Fill the charset with 0x55
    //memset_dma(CHARSET, 0x55, 256*64);

    for(char i=0, c=0;i<64;i++) {        
        CHARSET[i] = i;
        //CHARSET[i] = c?0:i;
        //c ^= 1;
        //if((i&7)==7) c ^= 1;
    }


    // Loop forever
    for(;;) {        
        VICIV->BORDER_COLOR = VICII->RASTER;
    }
}