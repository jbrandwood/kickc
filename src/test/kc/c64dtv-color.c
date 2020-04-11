// Test C64DTV v2 256-colors and the 16-color redefinable palette

#include <c64dtv.c>

void main() {
    asm { sei }
    *DTV_FEATURE = DTV_FEATURE_ENABLE;
    *DTV_CONTROL = DTV_HIGHCOLOR | DTV_BORDER_OFF | DTV_BADLINE_OFF;

    byte palette[16] =  { $0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $a, $b, $c, $d, $e, $f };

    while(true) {
        while(*RASTER!=$40) { }

        // Create rasterbars
        *BGCOL = 0;
        for (byte r : $31..$ff) {
            asm { nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop }
            (*BGCOL)++;
        }

        // Rotate palette
        for(byte c : 0..$f) {
            DTV_PALETTE[c] = palette[c];
            palette[c]++;
        }

    }
}