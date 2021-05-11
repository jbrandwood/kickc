// DYPP (Different Y Pixel Position) LOGO created using DMA
// Graphics mode is 45x25 full-colour super extended attribute mode text-mode
// Character layout is column-wise giving linear addressing of the graphics (one byte per pixel)

#pragma target(mega65)
#include <mega65.h>
#include <mega65-dma.h>
#include <6502.h>
#include <string.h>

// The screen address (45*25*2=0x08ca bytes)
char * const SCREEN = (char*)0x5000;
// The charset address (45*32*8=0x2d00 bytes)
char * const CHARSET = (char*)0x6000;
// A logo in column-wide linear single-color memory layout
char LOGO[45*25*8]  = kickasm(resource "camelot.png") {{
	.var pic = LoadPicture("camelot.png", List().add($ffffff, $000000))
	.for (var x=0;x<45; x++)
    	.for (var y=0; y<25*8; y++)
            .byte pic.getSinglecolorByte(x,y)
}};

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
    // Set sideborder width=0, disable raster delay and hot registers
    VICIV->SIDBDRWD_LO = 0;
    VICIV->SIDBDRWD_HI = 0;   
    // Disable top/bottom borders
    VICIV->TBDRPOS_LO = 0;
    VICIV->TBDRPOS_HI = 0;
    VICIV->BBDRPOS_LO = 0;
    VICIV->BBDRPOS_HI = 2;
    // Enable Super Extended Attribute Mode
    VICIV->CONTROLC |= 1;
    // Mode 40x25 chars - will be 45*25 when utilizing the borders
    VICIV->CONTROLB &= 0x7f;
    VICIV->CHARSTEP_LO = 90;
    VICIV->CHARSTEP_HI = 0;
    // Start text in the left border
    VICIV->TEXTXPOS_LO = 40;
    VICIV->TEXTXPOS_HI = 0;
    // Set number of characters to display per row
    VICIV->CHRCOUNT = 45;
    // Set exact screen address
    VICIV->SCRNPTR_LOLO = <SCREEN;
    VICIV->SCRNPTR_LOHI = >SCREEN;
    VICIV->SCRNPTR_HILO = 0;
    VICIV->SCRNPTR_HIHI = 0;
    // Set exact charset address
    VICIV->CHARPTR_LOLO = <CHARSET;
    VICIV->CHARPTR_LOHI = >CHARSET;
    VICIV->CHARPTR_HILO = 0;
    
    // Enable Full-Colour Mode
    //VICIV->CONTROLC |= 2|4;

    // Fill the screen with 0
    memset_dma(SCREEN, 0, 45*25*2);
    // Fill the colours with WHITE - directly into $ff80000
    memset_dma256(0xff,0x08,(void*)0x0000, WHITE, 45*25*2);
    // Fill the charset with 0x55
    memset_dma(CHARSET, 0x55, 45*32*8);

    // Extended screen (each char is an integer)
    unsigned int *ESCREEN = SCREEN;

    // Fill extended screen to achieve column-wise linear addressing
    unsigned int *erow = ESCREEN;    
    for(char r=0; r<25; r++) {
        unsigned int c = r;
        for(char i=0; i<45; i++) {
            erow[i] = c;
            c += 32; 
        }
        erow += 45;
    }

    //  Copy the LOGO to the CHARSET
    char* logo_dest = CHARSET;
    char* logo_src = LOGO;
    for(char col=0;col<45;col++) {
        for(char y=0;y<25*8;y++) {
            logo_dest[y] = logo_src[y];
        }
        logo_dest += 32*8;
        logo_src += 25*8;
    }

 
    // Loop forever
    for(;;) {        
        VICIV->BG_COLOR = VICII->RASTER;
    }
}