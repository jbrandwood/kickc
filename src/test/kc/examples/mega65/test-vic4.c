// Test a few VIC 3/4 features
#pragma target(mega65)
#include <mega65.h>

char * const SCREEN = (char *)0x0800;
char * const COLORS = (char *)0xd800;

char * const TBDRPOS = (char *)0xd048;
char * const TBDRPOS_HI = (char *)0xd049;

void main() {

    // Map memory to BANK 0 : 0x00XXXX - giving access to I/O
    asm { 
        sei 
        lda #0
        tax
        tay
        taz
        map
        eom
    }

    // Enable the VIC 4
    *IO_KEY = 0x47;
    *IO_KEY = 0x53;

    // Enable 2K Color RAM
    *IO_BANK |= CRAM2K;

    // Fill the screen with '*'
    for( char *sc = SCREEN; sc<SCREEN+2000; sc++)
        *sc = '*';
    // Fill the color memory
    for( char *col = COLORS; col<COLORS+2000; col++)
        *col = (char)col;

    // Loop forever
    for(;;)
        VICII->BORDER_COLOR = VICII->RASTER;

}