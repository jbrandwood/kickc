// Example program for the Commander X16.
// Demonstrates the usage of the VERA tile map modes and layering.

// Author: Sven Van de Velde

#include <veralib.h>
#include <printf.h>

void main() {

    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    vera_layer_mode_tile(0, 0x04000, 0x14000, 128, 128, 8, 8, 8);

    byte tiles[64] = {
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
    };

    word tilebase = 0x4000;
    memcpy_to_vram(1, tilebase, tiles, 64);
    tilebase+=64;
    for(byte t:1..255) {
        for(byte p:0..63) {
            tiles[p]+=1;
        }
        memcpy_to_vram(1, tilebase, tiles, 64);
        tilebase+=64;
    }

    //vera_tile_area(byte layer, word tileindex, byte x, byte y, byte w, byte h, byte hflip, byte vflip, byte offset)

    vera_tile_area(0, 0, 0, 0, 80, 60, 0, 0, 0);

    word tile = 0;

    // Draw 4 squares with each tile, starting from row 4, width 1, height 1, separated by 2 characters.
    byte row = 1;
    for(byte r:0..7) {
        byte column = 1;
        for(byte c:0..31) {
            vera_tile_area(0, tile, column, row, 1, 1, 0, 0, 0);
            column+=2;
            tile++;
            tile &= 0xff;
        }
        row += 2;
    }

    tile = 0;
    row = 20;
    for(byte r:0..7) {
        byte column = 1;
        for(byte c:0..31) {
            vera_tile_area(0, tile, column, row, 2, 2, 0, 0, 0);
            column+=2;
            tile++;
            tile &= 0xff;
        }
        row += 2;
    }

    vera_layer_show(0);

    gotoxy(0,50);
    printf("vera in tile mode 8 x 8, color depth 8 bits per pixel.\n");

    printf("in this mode, tiles are 8 pixels wide and 8 pixels tall.\n");
    printf("each tile can have a variation of 256 colors.\n");
    printf("the vera palette of 256 colors, can be used by setting the palette\n");
    printf("offset for each tile.\n");
    printf("here each column is displaying the same tile, but with different offsets!\n");
    printf("each offset aligns to multiples of 16 colors in the palette!.\n");
    printf("however, the first color will always be transparent (black).\n");

    while(!kbhit());
}
