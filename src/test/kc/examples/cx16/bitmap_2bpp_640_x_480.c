// Example program for the Commander X16.
// Demonstrates the usage of the VERA graphic modes and layering.

// Author: Sven Van de Velde

#include <conio.h>
#include <printf.h>
#include <bitmap-draw.h>
#include <stdlib.h>
#include <division.h>

void main() {

    // Before we configure the bitmap pane into vera  memory we need to re-arrange a few things!
    // It is better to load all in bank 0, but then there is an issue.
    // So the default CX16 character set is located in bank 0, at address 0xF800.
    // So we need to move this character set to bank 1, suggested is at address 0xF000.
    // The CX16 by default writes textual output to layer 1 in text mode, so we need to
    // realign the moved character set to 0xf000 as the new tile base for layer 1.
    // We also will need to realign for layer 1 the map base from 0x00000 to 0x14000.
    // This is now all easily done with a few statements in the new kickc vera lib ...
    memcpy_in_vram(1, 0xF000, VERA_INC_1, 0, 0xF800, VERA_INC_1, 256*8); // We copy the 128 character set of 8 bytes each.
    vera_layer_mode_tile(1, 0x14000, 0x1F000, 128, 64, 8, 8, 1);

    vera_layer_mode_bitmap(0, (dword)0x00000, 640, 2);

    screenlayer(1);
    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    gotoxy(0,54);
    printf("vera in bitmap mode,\n");
    printf("color depth 1 bits per pixel.\n");
    printf("in this mode, it is possible to display\n");
    printf("graphics in 2 colors (black or color).\n");

    vera_layer_show(0);

    bitmap_init(0, 0x00000);
    bitmap_clear();

    gotoxy(0,59);
    textcolor(YELLOW);
    printf("press a key ...");

    while(!kbhit()) {
        bitmap_line(modr16u(rand(),639,0), modr16u(rand(),639,0), modr16u(rand(),399,0), modr16u(rand(),399,0), rand()&3);
    };

    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    gotoxy(0,54);
    printf("here you see all the colors possible.\n");

    gotoxy(0,59);
    textcolor(YELLOW);
    printf("press a key ...");

    word x = 0;
    byte color = 0;
    while(!kbhit()) {
        bitmap_line(x, x, 0, 399, color);
        color++;
        if(color>3) color=0;
        x++;
        if(x>639) x=0;
    };

    screenlayer(1);
    textcolor(WHITE);
    bgcolor(BLUE);
    clrscr();

}
