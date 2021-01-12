// Example program for the Commander X16.
// Demonstrates the usage of the VERA layer 0 and 1.

// Author: Sven Van de Velde

// The default layer of the CS16 is layer 1.
// The CS16 starts in tile map mode, 1BPP in 16 color mode, and uses 8x8 tiles.
// The map base is address 0x00000 in VERA VRAM, the tile map is address 0x1F000.

#include <veralib.h>
#include <printf.h>

void main() {

    textcolor(WHITE);
    bgcolor(GREEN);
    clrscr();

    dword tilebase = vera_get_layer_tilebase_address(1);
    dword tilecolumn = tilebase;
    dword tilerow = tilebase;

    for(byte y:0..6) {
        tilerow = tilebase;
        for(byte r:0..7) {
            tilecolumn = tilerow;
            for(byte x:0..9) {
                vera_vram_address0(tilecolumn,VERA_INC_0);
                byte data = *VERA_DATA0;
                byte bit = data;
                for(byte b:8..1) {
                    bit = (data >> (b-1)) & $1;
                    printf("%c", (char)((bit)?'*':'.'));
                }
                tilecolumn += 8;
                printf("");
            }
            //printf("\n");
            tilerow += 1;
        }
        tilebase += 8*10;
    }
}