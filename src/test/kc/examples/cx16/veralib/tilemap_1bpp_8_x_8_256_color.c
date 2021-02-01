// Example program for the Commander X16.
// Demonstrates the usage of the VERA tile map modes and layering.

// Author: Sven Van de Velde

#pragma target(cx16)
#include <cx16.h>
#include <cx16-veralib.h>
#include <printf.h>

void main() {

    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    // Configure the VERA card to work in text, 256 mode.
   // The color mode is here 256 colors, (256 foreground on a black transparent background).
     vera_layer_mode_text( 1, 0x00000, 0x0F800, 128, 128, 8, 8, 256 );

    // or you can use the below statement, but that includes setting a "mode", including
    // layer, map base address, tile base address, map width, map height, tile width, tile height, color mode.
    //vera_layer_mode_text(1, 0x00000, 0x0F800, 128, 128, 8, 8, 256);

    for(byte c:0..255) {
        textcolor(c);
        printf(" ****** ");
    }

    vera_layer_show(1);

    gotoxy(0,50);
    textcolor(WHITE);
    bgcolor(BLACK);
    printf("vera in text mode 8 x 8, color depth 1 bits per pixel.\n");
    printf("in this mode, tiles are 8 pixels wide and 8 pixels tall.\n");
    printf("each character can have a variation of 256 foreground colors.\n");
    printf("here we display 6 stars (******) each with a different color.\n");
    printf("however, the first color will always be transparent (black).\n");
    printf("in this mode, the background color cannot be set and is always transparent.\n");

    while(!kbhit());
}
