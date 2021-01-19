// Example program for the Commander X16.
// Demonstrates the usage of the VERA tile map modes and layering.

// Author: Sven Van de Velde

// The default layer of the CX16 is layer 1, but the tiles are written on layer 0.
// The CX16 starts in tile map mode, 1BPP in 16 color mode, and uses 8x8 tiles.

// An explanation is given how this mode is organized, and how the tiles display and coloring works.
// Pälette offsets are explained also.

#include <veralib.h>
#include <printf.h>

void main() {

    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    // Configure the VERA card to work in text, 16x16 mode.
    // The color mode is here 16 colors, indicating 16x16 color mode, (16 foreground and 16 background colors).
    vera_layer_set_text_color_mode( 1, VERA_LAYER_CONFIG_16C );

    // or you can use the below statement, but that includes setting a "mode", including
    // layer, map base address, tile base address, map width, map height, tile width, tile height, color mode.
    //vera_layer_mode_text(1, 0x00000, 0x0F800, 128, 128, 8, 8, 16);

    for(byte c:0..255) {
        bgcolor(c);
        printf(" ****** ");
    }

    vera_layer_show(1);

    gotoxy(0,50);
    textcolor(WHITE);
    bgcolor(BLACK);
    printf("vera in text mode 8 x 8, color depth 1 bits per pixel.\n");
    printf("in this mode, tiles are 8 pixels wide and 8 pixels tall.\n");
    printf("each character can have a variation of 16 foreground colors and 16 background colors.\n");
    printf("here we display 6 stars (******) each with a different color.\n");
    printf("however, the first color will always be transparent (black).\n");
    printf("in this mode, the background color cannot be set and is always transparent.\n");

    while(!kbhit());
}
