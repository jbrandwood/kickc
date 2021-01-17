// Example program for the Commander X16.
// Demonstrates the usage of the VERA tile map modes and layering.

// Author: Sven Van de Velde

// The default layer of the CX16 is layer 1, but the tiles are written on layer 0.

// An explanation is given how this mode is organized, and how the tiles display and coloring works.
// Pälette offsets are explained also.

#include <conio.h>
#include <printf.h>

void main() {


    byte tiles[256] = {
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
        0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    };

    // Before we can load the tiles into memory we need to re-arrange a few things!
    // The amount of tiles is 256, the color depth is 256, so each tile is 256 bytes!
    // That is 65356 bytes of memory, which is 64K. Yup! One memory bank in VRAM.
    // VERA VRAM holds in bank 1 many registers that interfere loading all of this data.
    // So it is better to load all in bank 0, but then there is an other issue.
    // So the default CX16 character set is located in bank 0, at address 0xF800.
    // So we need to move this character set to bank 1, suggested is at address 0xF000.
    // The CX16 by default writes textual output to layer 1 in text mode, so we need to
    // realign the moved character set to 0xf000 as the new tile base for layer 1.
    // We also will need to realign for layer 1 the map base from 0x00000 to 0x10000.
    // This is now all easily done with a few statements in the new kickc vera lib ...

    // Copy block of memory (from VRAM to VRAM)
    // Copies the values from the location pointed by src to the location pointed by dest.
    // The method uses the VERA access ports 0 and 1 to copy data from and to in VRAM.
    // - src_bank:  64K VRAM bank number to copy from (0/1).
    // - src: pointer to the location to copy from. Note that the address is a 16 bit value!
    // - src_increment: the increment indicator, VERA needs this because addressing increment is automated by VERA at each access.
    // - dest_bank:  64K VRAM bank number to copy to (0/1).
    // - dest: pointer to the location to copy to. Note that the address is a 16 bit value!
    // - dest_increment: the increment indicator, VERA needs this because addressing increment is automated by VERA at each access.
    // - num: The number of bytes to copy
    // void memcpy_in_vram(char dest_bank, void *dest, char dest_increment, char src_bank, void *src, char src_increment, unsigned int num );
    memcpy_in_vram(1, 0xF000, VERA_INC_1, 0, 0xF800, VERA_INC_1, 256*8); // We copy the 128 character set of 8 bytes each.


    vera_layer_mode_tile(1, 0x10000, 0x1F000, 128, 64, 8, 8, 1);

    screenlayer(1);
    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    // Now we can use the full bank 0!
    // We set the mapbase of the tile demo to output to 0x12000,
    // and the tilebase is set to 0x0000!
    vera_layer_mode_tile(0, 0x14000, 0x00000, 64, 64, 16, 16, 8);


    word tilebase = 0x0000;
    memcpy_to_vram(0, tilebase, tiles, 256);
    tilebase+=256;
    for(byte t:1..255) {
        for(byte p:0..255) {
            tiles[p]+=1;
        }
        memcpy_to_vram(0, tilebase, tiles, 256);
        tilebase+=256;
    }

    //vera_tile_area(byte layer, word tileindex, byte x, byte y, byte w, byte h, byte hflip, byte vflip, byte offset)

    vera_tile_area(0, 0, 0, 0, 40, 30, 0, 0, 0);

    word tile = 0;

    // Draw 4 squares with each tile, starting from row 4, width 1, height 1, separated by 2 characters.
    byte row = 1;
    for(byte r:0..11) {
        byte column = 0;
        for(byte c:0..19) {
            vera_tile_area(0, tile, column, row, 1, 1, 0, 0, 0);
            column+=2;
            tile++;
            tile &= 0xff;
        }
        row += 2;
    }

    gotoxy(0,50);
    printf("vera in tile mode 8 x 8, color depth 8 bits per pixel.\n");

    printf("in this mode, tiles are 8 pixels wide and 8 pixels tall.\n");
    printf("each tile can have a variation of 256 colors.\n");
    printf("the vera palette of 256 colors, can be used by setting the palette\n");
    printf("offset for each tile.\n");
    printf("here each column is displaying the same tile, but with different offsets!\n");
    printf("each offset aligns to multiples of 16 colors in the palette!.\n");
    printf("however, the first color will always be transparent (black).\n");

    vera_layer_show(0);

    while(!kbhit());

    vera_tile_area(0, 0, 0, 0, 40, 30, 0, 0, 0);

    tile = 0;
    row = 0;
    for(byte r:0..11) {
        byte column = 0;
        for(byte c:0..19) {
            vera_tile_area(0, tile, column, row, 2, 2, 0, 0, 0);
            column+=2;
            tile++;
            tile &= 0xff;
        }
        row += 2;
    }

    while(!kbhit());

    // Now put back the defaults ...
    vera_tile_area(0, 0, 0, 0, 40, 30, 0, 0, 0);
    vera_layer_hide(0);
    memcpy_in_vram(0, 0xF800, VERA_INC_1, 1, 0xF000, VERA_INC_1, 256*8);
    vera_layer_mode_tile(1, 0x00000, 0x0F800, 128, 128, 8, 8, 1);
    vera_layer_mode_tile(0, 0x00000, 0x0F800, 128, 128, 8, 8, 1);

    screenlayer(1);
    textcolor(WHITE);
    bgcolor(BLUE);
    clrscr();

}
