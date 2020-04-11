// C64DTV 8bpp charmode stretcher
#include <c64dtv.c>

// Plane with all pixels
byte* const CHUNKY = $8000;

void main() {
    asm { sei }  // Disable normal interrupt (prevent keyboard reading glitches and allows to hide basic/kernal)
    // Disable kernal & basic
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
    gfx_init_chunky();
    // Enable DTV extended modes
    *DTV_FEATURE = DTV_FEATURE_ENABLE;
    // 8BPP Pixel Cell Mode
    *DTV_CONTROL = DTV_HIGHCOLOR | DTV_LINEAR | DTV_COLORRAM_OFF | DTV_CHUNKY | DTV_BADLINE_OFF;
    *VIC_CONTROL = VIC_DEN | VIC_ECM | VIC_RSEL | 3;
    *VIC_CONTROL2 = VIC_MCM | VIC_CSEL;
    // Plane B: CHUNKY
    *DTV_PLANEB_START_LO = < CHUNKY;
    *DTV_PLANEB_START_MI = > CHUNKY;
    *DTV_PLANEB_START_HI = 0;
    *DTV_PLANEB_STEP = 8;
    *DTV_PLANEB_MODULO_LO = 0;
    *DTV_PLANEB_MODULO_HI = 0;
    // VIC Graphics Bank
    *CIA2_PORT_A_DDR = %00000011; // Set VIC Bank bits to output - all others to input
    *CIA2_PORT_A = %00000011 ^ (byte)((word)CHUNKY/$4000); // Set VIC Bank
    // VIC memory
    *VIC_MEMORY = (byte)((((word)CHUNKY)&$3fff)/$40)  |   ((>(((word)CHUNKY)&$3fff))/4);

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

        *VIC_CONTROL = VIC_DEN | VIC_ECM | VIC_RSEL | 3;
        *BORDERCOL = 0;
        byte rst = $42;
        while(*RASTER!=rst) {}
        asm { nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop }
        do {
            rst = *RASTER;
            *VIC_CONTROL = VIC_DEN | VIC_ECM | VIC_RSEL | (rst&7);
            *BORDERCOL = rst*$10;
            asm { nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop }
        } while (rst!=$f2);
    }
}

// Initialize Plane with 8bpp chunky
void gfx_init_chunky() {
    // 320x200 8bpp pixels for Plane
    byte gfxbCpuBank = (byte)(CHUNKY/$4000);
    dtvSetCpuBankSegment1(gfxbCpuBank++);
    byte* gfxb = $4000;
    for(byte y : 0..50) {
        for (word x : 0..319) {
            // If we have crossed to $8000 increase the CPU BANK segment and reset to $4000
            if(gfxb==$8000) {
                dtvSetCpuBankSegment1(gfxbCpuBank++);
                gfxb = $4000;
            }
            byte c = (byte)(x+y);
            *gfxb++ = c;
        }
    }
    // Reset CPU BANK segment to $4000
    dtvSetCpuBankSegment1((byte)($4000/$4000));
}