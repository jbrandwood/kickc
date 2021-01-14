// Example program for the Commander X16.
// Demonstrates the usage of the VERA tile map modes and layering.

// Author: Sven Van de Velde

// The default layer of the CX16 is layer 1, but the tiles are written on layer 0.
// The CX16 starts in tile map mode, 2BPP in 4 color mode, and uses 8x8 tiles.

// An explanation is given how this mode is organized, and how the tiles display and coloring works.
// Pälette offsets are explained also.

#include <veralib.h>
#include <printf.h>

void main() {

    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    vera_mode_tile(0, 0x04000, 0x14000, 128, 128, 8, 8, 2);

    byte tiles[64] = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
                     0x55,0x55,0x55,0x55,0x55,0x55,0x55,0x55,0x55,0x55,0x55,0x55,0x55,0x55,0x55,0x55,
                     0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,
                     0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF};

    byte map[16] =  {0x00,0x00,0x00,0x00,0x01,0x00,0x01,0x00,0x02,0x00,0x02,0x00,0x03,0x00,0x03,0x00};

    memcpy_to_vram(1, 0x4000, tiles, 64);

    //vera_tile_area(byte layer, word tileindex, byte x, byte y, byte w, byte h, byte hflip, byte vflip, byte offset)

    vera_tile_area(0, 0, 0, 0, 80, 60, 0, 0, 0);

    // Draw 4 squares with each tile, staring from row 2, width 10, height 10, separated by 2 characters.
    vera_tile_area(0, 0, 4, 4, 10, 10, 0, 0, 0);
    vera_tile_area(0, 1, 16, 4, 10, 10, 0, 0, 0);
    vera_tile_area(0, 2, 28, 4, 10, 10, 0, 0, 0);
    vera_tile_area(0, 3, 40, 4, 10, 10, 0, 0, 0);

    word tile = 0;
    byte offset = 0;

    byte row = 22;

    for(byte r:0..3) {
        byte column = 4;
        for(byte c:0..15) {
            vera_tile_area(0, tile, column, row, 3, 3, 0, 0, offset);
            column+=4;
            offset++;
        }
        tile++;
        tile &= 0x3;
        row += 4;
    }

    vera_show_layer(0);

    gotoxy(0,40);
    printf("vera in tile mode 8 x 8, color depth 2 bits per pixel.\n");

    printf("in this mode, tiles are 8 pixels wide and 8 pixels tall.\n");
    printf("each tile can have a variation of 4 colors.\n");
    printf("the vera palette of 256 colors, can be used by setting the palette\n");
    printf("offset for each tile.\n");
    printf("here each column is displaying the same tile, but with different offsets!\n");
    printf("each offset aligns to multiples of 16 colors, and only the first 4 colors\n");
    printf("can be used per offset!\n");
    printf("however, the first color will always be transparent (black).\n");

    while(!kbhit());
}
