#include <c64.h>

void main() {
    asm {
        sei
    }
    do {
        do {} while (*RASTER!=$a);
        do {} while (*RASTER!=$b);
        raster();
    } while (true);
}

char rastercols[] = { $b, $0, $b, $b, $c, $b, $c, $c, $f, $c, $f, $f, $1, $f, $1, $1, $f, $1, $f, $f, $c, $f, $c, $c, $b, $c, $b, $b, $0, $b, $0, $ff };


void raster() {
    asm {
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
    }
    char i = 0;
    char col = rastercols[i];
    do {
       *BGCOL = col;
       *BORDERCOL = col;
       col  = rastercols[++i];
       asm {
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
        }
    } while (col!=$ff);

}