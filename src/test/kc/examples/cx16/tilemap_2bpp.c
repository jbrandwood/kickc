// Example program for the Commander X16.
// Demonstrates the usage of the VERA tile map modes and layering.

// Author: Sven Van de Velde

// The default layer of the CX16 is layer 1, but the tiles are written on layer 0.
// The CX16 starts in tile map mode, 2BPP in 4 color mode, and uses 8x8 tiles.
// The map base is address 0x10000 in VERA VRAM.
// The tile base is address 0x0800 in VERA VRAM.
// We are displaying 128 tiles vertically and 128 tiles horizontally.
// The tile base is from 64 tiles.

#include <veralib.h>
#include <printf.h>
#include <6502.h>

void main() {

    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    // Now we set the tile map width and height.
    vera_set_layer_mapbase(0,0x80); // Set the map base to address 0x10000 in VERA VRAM!
    vera_set_layer_config(0, vera_get_layer_config(1));
    vera_set_layer_color_depth_2BPP(0);
    vera_set_layer_tilebase(0, 0xA0);
    vera_set_layer_map_width_128(0);
    vera_set_layer_map_height_64(0);
    dword tilebase = vera_get_layer_tilebase_address(0);
    vera_show_layer(0);

    byte tile[64] = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
                     0x55,0x55,0x55,0x55,0x55,0x55,0x55,0x55,0x55,0x55,0x55,0x55,0x55,0x55,0x55,0x55,
                     0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,
                     0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF};
    byte map[16] = {0x00,0x00,0x00,0x00,0x01,0x00,0x01,0x00,0x02,0x00,0x02,0x00,0x03,0x00,0x03,0x00};

    memcpy_to_vram(1, 0x4000, tile, 64);
    memcpy_to_vram(1, 0x0000, map, 16);


    while(!kbhit());

    screenlayer(0);
    scroll(1); // Scrolling on conio is activated, so conio will not output beyond the borders of the visible screen.
    textcolor(WHITE);
    bgcolor(GREEN);

    draw_characters(tilebase);

    while(!kbhit());

    // Enable VSYNC IRQ (also set line bit 8 to 0)
    SEI();
    *KERNEL_IRQ = &irq_vsync;
    *VERA_IEN = VERA_VSYNC;
    CLI();


    vera_hide_layer(0);
    textcolor(GREY);
    bgcolor(GREEN);
    draw_characters(tilebase);
    vera_show_layer(0);

    screenlayer(1);

    textcolor(WHITE);
    bgcolor(BLACK);
    printf("\n\nthis demo displays the design of the standard x16 commander\n");
    printf("character set on the vera layer 0. it's the character set i grew up with :-).\n");
    printf("\nthe smooth scrolling is implemented by manipulating the scrolling \n");
    printf("registers of layer 0. at each raster line interrupt, \n");
    printf("the x and y scrolling registers are manipulated. the cx16 terminal \n");
    printf("works on layer 1. when layer 0 is enabled with the scrolling, \n");
    printf("it gives a nice background effect. this technique can be used to implement\n");
    printf("smooth scrolling backgrounds using tile layouts in games or demos.\n");

    textcolor(YELLOW);
    printf("\npress a key to continue ...");

    while(!kbhit());

    screenlayer(0);
    vera_hide_layer(0);
    textcolor(DARK_GREY);
    bgcolor(BLACK);
    draw_characters(tilebase);
    vera_show_layer(0);

    screenlayer(1);
    gotoxy(0,20);

}

void draw_characters(dword tilebase) {
    dword tilecolumn = tilebase;
    dword tilerow = tilebase;
    clrscr();

    for(byte y:0..15) {
        printf("@");
    }
}

// X sine index
volatile int scroll_x = 0;
volatile int scroll_y = 0;
volatile int delta_x = 2;
volatile int delta_y = 0;
volatile int speed = 2;

// VSYNC Interrupt Routine
__interrupt(rom_sys_cx16) void irq_vsync() {


    scroll_x += delta_x;
    scroll_y += delta_y;

    if( scroll_x>(128*8-80*8)) {
        delta_x = 0;
        delta_y = speed;
        scroll_x = (128*8-80*8);
    }
    if( scroll_y>(128*8-60*8)) {
        delta_x = -speed;
        delta_y = 0;
        scroll_y = (128*8-60*8);
    }
    if(scroll_x<0) {
        delta_x = 0;
        delta_y = -speed;
        scroll_x = 0;
    }
    if(scroll_y<0) {
        delta_x = speed;
        delta_y = 0;
        scroll_y = 0;
   }

    vera_set_layer_horizontal_scroll(0,(word)scroll_x);
    vera_set_layer_vertical_scroll(0,(word)scroll_y);

    // Reset the VSYNC interrupt
    *VERA_ISR = VERA_VSYNC;
}