// Example program for the Commander X16.
// Demonstrates the usage of the VERA layer 0 and 1.

// Author: Sven Van de Velde

// The default layer of the CX16 is layer 1.
// The CX16 starts in tile map mode, 1BPP in 16 color mode, and uses 8x8 tiles.
// The map base is address 0x00000 in VERA VRAM, the tile map is address 0x0F800.

#pragma target(cx16)
#include <conio.h>
#include <stdio.h>
#include <veralib.h>

void main() {

    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    // Wait for a keypress and after clear the line!
    textcolor(YELLOW);
    printf("press a key");
    while(!kbhit());
    clearline();

    screenlayer(1);

    gotoxy(0,16);
    textcolor(GREEN);

    printf("this program demonstrates the layer functionality in text mode.\n");

    // Here we use the screensizex and screensizey functions to show the width and height of the text screen.
    printf("\nvera card width = %u; height = %u\n", screensizex(), screensizey());

    // This is the content of the main controller registers of the VERA of layer 1.
    // Layer 1 is the default layer that is activated in the CX16 at startup.
    // It displays the characters in 1BPP 16x16 color mode!
    unsigned byte dcvideo = *VERA_DC_VIDEO;
    printf("\nvera dc video = %x\n", dcvideo);
    unsigned byte config = vera_get_layer_config(1);
    printf("\nvera layer 1 config = %x\n", config);
    unsigned byte layershown = vera_is_layer_shown(1);
    printf("vera layer 1 shown = %c\n", layershown);
    unsigned byte mapbase = vera_get_layer_mapbase(1);
    unsigned byte tilebase = vera_get_layer_tilebase(1);
    printf("vera layer 1 mapbase = %hhx, tilebase = %hhx\n", mapbase, tilebase);

    // Wait for a keypress and after clear the line!
    textcolor(YELLOW);
    printf("press a key");
    while(!kbhit());
    clearline();

    // Now we continue with demonstrating the layering!
    // We set the mapbase of layer 0 to an address in VRAM.
    // We copy the tilebase address from layer 1, so that we reference to the same tilebase.
    // We print a text on layer 0, which of course, won't yet be displayed,
    // because we haven't activated layer 0 on the VERA.
    // But the text will be printed and awaiting to be displayer later, once we activate layer 0!
    // But first, we also print the layer 0 VERA configuration.
    // This statement sets the base of the display layer 1 at VRAM address 0x0200

    vera_set_layer_mapbase(0,0x80); // Set the map base to address 0x10000 in VERA VRAM!
    vera_set_layer_config(0, vera_get_layer_config(1));
    vera_set_layer_tilebase(0, vera_get_layer_tilebase(1));

    textcolor(WHITE);
    config = vera_get_layer_config(0);
    printf("\nvera layer 0 config = %x\n", vera_get_layer_config(0));
    layershown = vera_is_layer_shown(0);
    printf("vera layer 0 shown = %x\n", layershown);
    mapbase = vera_get_layer_mapbase(0);
    tilebase = vera_get_layer_tilebase(0);
    printf("vera layer 0 mapbase = %x, tilebase = %x\n", mapbase, tilebase);

    // Now we print the layer 0 text on the layer 0!
    screenlayer(0); // We set conio to output to layer 0 instead of layer 1!
    textcolor(BLUE);
    bgcolor(BLACK);
    clrscr(); // We clear the screen of layer 0!
    bgcolor(WHITE);
    gotoxy(19,4);
    printf("                                        ");
    gotoxy(19,5);
    printf("     this is printed on layer 0 !!!     ");
    gotoxy(19,6);
    printf("                                        ");

    screenlayer(1); // Now we ask conio again to output to layer 1!

    // Wait for a keypress and after clear the line!
    textcolor(YELLOW);
    bgcolor(BLACK);
    printf("press a key to show layer 0 and show the text!");
    while(!kbhit());
    clearline();

    // Now we activate layer 0.
    vera_show_layer(0);
    textcolor(WHITE);
    bgcolor(BLACK);
    printf("vera layer 0 shown = %x. ", vera_is_layer_shown(0));

    // Wait for a keypress and after clear the line!
    textcolor(YELLOW);
    bgcolor(BLACK);
    printf("press a key to hide layer 0 and hide the text again");
    while(!kbhit());
    clearline();

    vera_hide_layer(0);
    textcolor(WHITE);
    bgcolor(BLACK);
    printf("vera layer 0 shown = %x. ", vera_is_layer_shown(0));

  // Wait for a keypress and after clear the line!
    textcolor(YELLOW);
    bgcolor(BLACK);
    printf("press a key to finish");
    while(!kbhit());
    clearline();

    clrscr();
    textcolor(RED);
    bgcolor(WHITE);
    gotoxy(19,10);
    printf("                                     ");
    gotoxy(19,11);
    printf("     analyze the code and learn!     ");
    gotoxy(19,12);
    printf("                                     ");
}
