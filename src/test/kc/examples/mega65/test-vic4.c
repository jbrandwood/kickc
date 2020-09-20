// Hello World for MEGA 65 - putting chars directly to the screen
#pragma target(mega65)
#include <mega65.h>

char * const SCREEN = 0x0800;
char * const COLORS = 0xd800;

char * const TBDRPOS = 0xd048;
char * const TBDRPOS_HI = 0xd049;

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
        *col = <col;



    /*
    // Set Border-color
    VICII->BORDER_COLOR = 0xff;
    VICII->BG_COLOR = 0x0b;
    for(;;) {
        while(VICII->RASTER!=0xfe) ;
        while(VICII->RASTER!=0xff) ;
        (*TBDRPOS)++;
    }
    */

   // Loop forever
    //for(;;) {
    //    VICII->BORDER_COLOR = VICII->RASTER;
    //}

}