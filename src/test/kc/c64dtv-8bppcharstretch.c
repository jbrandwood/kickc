// C64DTV 8bpp charmode stretcher
#include <c64dtv.h>

// Plane with the screen
byte* const SCREEN = $7c00;
// Plane with all pixels
byte* const CHARSET8 = $8000;

void main() {
    asm { sei }  // Disable normal interrupt (prevent keyboard reading glitches and allows to hide basic/kernal)
    // Disable kernal & basic
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
    gfx_init();
    // Enable DTV extended modes
    *DTV_FEATURE = DTV_FEATURE_ENABLE;
    // 8BPP Pixel Cell Mode
    *DTV_CONTROL = DTV_HIGHCOLOR | DTV_LINEAR | DTV_CHUNKY | DTV_BADLINE_OFF;
    *VICII_CONTROL = VICII_DEN | VICII_ECM | VICII_RSEL | 3;
    *VICII_CONTROL2 = VICII_MCM | VICII_CSEL;
    // Plane A: SCREEN
    *DTV_PLANEA_START_LO = < SCREEN;
    *DTV_PLANEA_START_MI = > SCREEN;
    *DTV_PLANEA_START_HI = 0;
    *DTV_PLANEA_STEP = 1;
    *DTV_PLANEA_MODULO_LO = 0;
    *DTV_PLANEA_MODULO_HI = 0;
    // Plane B: CHARSET8
    *DTV_PLANEB_START_LO = < CHARSET8;
    *DTV_PLANEB_START_MI = > CHARSET8;
    *DTV_PLANEB_START_HI = 0;
    *DTV_PLANEB_STEP = 0;
    *DTV_PLANEB_MODULO_LO = 0;
    *DTV_PLANEB_MODULO_HI = 0;
    // VIC Graphics Bank
    CIA2->PORT_A_DDR = %00000011; // Set VIC Bank bits to output - all others to input
    CIA2->PORT_A = %00000011 ^ (byte)((word)SCREEN/$4000); // Set VIC Bank
    // VIC memory
    *VICII_MEMORY = (byte)((((word)SCREEN)&$3fff)/$40)  |   ((>(((word)SCREEN)&$3fff))/4);

    // DTV Palette - Grey Tones
    for(byte j : 0..$f) {
        DTV_PALETTE[j] = j;
    }
    while(true) {
        // Stabilize Raster
        asm {
            ldx #$ff
        rff:
            cpx RASTER
            bne rff
        stabilize:
            nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop
            cpx RASTER
            beq eat+0
        eat:
            inx
            cpx #$08
            bne stabilize
        }

        *VICII_CONTROL = VICII_DEN | VICII_ECM | VICII_RSEL | 3;
        *BORDER_COLOR = 0;
        byte rst = $42;
        while(*RASTER!=rst) {}
        asm { nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop }
        do {
            rst = *RASTER;
            *VICII_CONTROL = VICII_DEN | VICII_ECM | VICII_RSEL | (rst&7);
            *BORDER_COLOR = rst*$10;
            asm { nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop }
        } while (rst!=$f2);
    }
}


// Initialize the different graphics in the memory
void gfx_init() {
    gfx_init_screen0();
    gfx_init_plane_charset8();
}

// Initialize VIC screen 0 ( value is %yyyyxxxx where yyyy is ypos and xxxx is xpos)
void gfx_init_screen0() {
    byte* ch=SCREEN;
    for(byte cy: 0..24 ) {
        for(byte cx: 0..39) {
            *ch++ = (cy&$f)*$10|(cx&$f);
        }
    }
}

// Initialize Plane with 8bpp charset
void gfx_init_plane_charset8() {
    // 8bpp cells for Plane B (charset) - ROM charset with 256 colors
    byte gfxbCpuBank = (byte)(CHARSET8/$4000);
    dtvSetCpuBankSegment1(gfxbCpuBank++);
    byte* gfxa = $4000 + (((word)CHARSET8)& $3fff);
    byte* chargen = CHARGEN+1;
    *PROCPORT = PROCPORT_RAM_CHARROM;
    byte col = 0;
    for(byte ch : $00..$ff) {
        for ( byte cr : 0..7) {
            byte bits = *chargen++;
            for ( byte cp : 0..7) {
                byte c = 0;
                if((bits & $80) != 0) {
                    c = col;
                }
                *gfxa++ = c;
                bits = bits*2;
                col++;
            }
        }
    }
    *PROCPORT = PROCPORT_RAM_IO;
    // Reset CPU BANK segment to $4000
    dtvSetCpuBankSegment1((byte)($4000/$4000));
}
