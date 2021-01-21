// Example program for the Commander X16.
// Demonstrates the usage of the VERA tile map modes and layering.

// Author: Sven Van de Velde

#include <veralib.h>
#include <stdio.h>

#include <bitmap-draw.h>
#include <stdlib.h>
#include <division.h>

void main() {

    // Configure the VERA card to work in text, 16x16 mode.
    // The color mode is here 16 colors, indicating 16x16 color mode, (16 foreground and 16 background colors).
    vera_layer_set_text_color_mode( 1, VERA_LAYER_CONFIG_16C );

    do {
        textcolor(WHITE);
        bgcolor(BLUE);
        clrscr();

        printf( "\n *** vera demo ***\n\n" );
        printf( "1. bitmap mode - 320 x 240 - 1 bit per pixel.\n");
        printf( "2. bitmap mode - 640 x 480 - 1 bit per pixel.\n");
        printf( "3. bitmap mode - 320 x 240 - 2 bits per pixel.\n");
        printf( "4. bitmap mode - 640 x 480 - 2 bits per pixel.\n");
        printf( "5. bitmap mode - 320 x 240 - 4 bits per pixel.\n");
        printf( "6. bitmap mode - 320 x 240 - 8 bits per pixel.\n");

        byte menu = 0;
        while(menu==0) {
            menu = fgetc();
        }

        switch( menu ) {
            case 49:
                bitmap_320_x_240_1BPP();
                break;
            case 50:
                bitmap_640_x_480_1BPP();
                break;
            case 51:
                bitmap_320_x_240_2BPP();
                break;
            case 52:
                bitmap_640_x_480_2BPP();
                break;
            case 53:
                bitmap_320_x_240_4BPP();
                break;
            case 54:
                bitmap_320_x_240_8BPP();
                break;
        }

        vera_layer_hide(0);
        memcpy_in_vram(0, 0xF800, VERA_INC_1, 1, 0xF000, VERA_INC_1, 256*8); // We copy the 128 character set of 8 bytes each.
        vera_layer_mode_tile(1, 0x00000, 0x0F800, 128, 64, 8, 8, 1);
        vera_layer_show(1);

        screenlayer(1);
        textcolor(WHITE);
        bgcolor(BLUE);
        clrscr();

    } while( menu != 58 );

}

void bitmap_320_x_240_1BPP() {

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

    vera_layer_mode_bitmap(0, (dword)0x00000, 320, 1);

    screenlayer(1);
    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    gotoxy(0,25);
    printf("vera in bitmap mode,\n");
    printf("color depth 1 bits per pixel.\n");
    printf("in this mode, it is possible to display\n");
    printf("graphics in 2 colors (black or color).\n");

    vera_layer_show(0);

    bitmap_init(0, 0x00000);
    bitmap_clear();

    gotoxy(0,29);
    textcolor(YELLOW);
    printf("press a key ...");

    while(!fgetc()) {
        bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&1);
    };

    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    gotoxy(0,26);
    printf("here you see all the colors possible.\n");

    gotoxy(0,29);
    textcolor(YELLOW);
    printf("press a key ...");

    word x = 0;
    byte color = 0;
    while(!fgetc()) {
        bitmap_line(x, x, 0, 199, color);
        color++;
        if(color>1) color=0;
        x++;
        if(x>319) x=0;
    };

}

void bitmap_640_x_480_1BPP() {

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

    vera_layer_mode_bitmap(0, (dword)0x00000, 640, 1);

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

    while(!fgetc()) {
        bitmap_line(modr16u(rand(),639,0), modr16u(rand(),639,0), modr16u(rand(),399,0), modr16u(rand(),399,0), rand()&1);
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
    while(!fgetc()) {
        bitmap_line(x, x, 0, 399, color);
        color++;
        if(color>1) color=0;
        x++;
        if(x>639) x=0;
    };

}

void bitmap_320_x_240_2BPP() {

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

    vera_layer_mode_bitmap(0, (dword)0x00000, 320, 2);

    screenlayer(1);
    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    gotoxy(0,25);
    printf("vera in bitmap mode,\n");
    printf("color depth 2 bits per pixel.\n");
    printf("in this mode, it is possible to display\n");
    printf("graphics in 4 colors.\n");

    vera_layer_show(0);

    bitmap_init(0, 0x00000);
    bitmap_clear();

    gotoxy(0,29);
    textcolor(YELLOW);
    printf("press a key ...");

    while(!fgetc()) {
        bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&3);
    };

    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    gotoxy(0,26);
    printf("here you see all the colors possible.\n");

    gotoxy(0,29);
    textcolor(YELLOW);
    printf("press a key ...");

    word x = 0;
    byte color = 0;
    while(!fgetc()) {
        bitmap_line(x, x, 0, 199, color);
        color++;
        if(color>3) color=0;
        x++;
        if(x>319) x=0;
    };
}

void bitmap_640_x_480_2BPP() {

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

    while(!fgetc()) {
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
    while(!fgetc()) {
        bitmap_line(x, x, 0, 399, color);
        color++;
        if(color>3) color=0;
        x++;
        if(x>639) x=0;
    };
}

void bitmap_320_x_240_4BPP() {

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

    vera_layer_mode_bitmap(0, (dword)0x00000, 320, 4);

    screenlayer(1);
    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    gotoxy(0,25);
    printf("vera in bitmap mode,\n");
    printf("color depth 4 bits per pixel.\n");
    printf("in this mode, it is possible to display\n");
    printf("graphics in 16 colors.\n");

    vera_layer_show(0);

    bitmap_init(0, 0x00000);
    bitmap_clear();

    gotoxy(0,29);
    textcolor(YELLOW);
    printf("press a key ...");

    while(!fgetc()) {
        bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&15);
    };

    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    gotoxy(0,26);
    printf("here you see all the colors possible.\n");

    gotoxy(0,29);
    textcolor(YELLOW);
    printf("press a key ...");

    word x = 0;
    byte color = 0;
    while(!fgetc()) {
        bitmap_line(x, x, 0, 199, color);
        color++;
        if(color>15) color=0;
        x++;
        if(x>319) x=0;
    };
}

void bitmap_320_x_240_8BPP() {

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

    vera_layer_mode_bitmap(0, (dword)0x00000, 320, 8);

    screenlayer(1);
    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    gotoxy(0,25);
    printf("vera in bitmap mode,\n");
    printf("color depth 8 bits per pixel.\n");
    printf("in this mode, it is possible to display\n");
    printf("graphics in 256 colors.\n");

    vera_layer_show(0);

    bitmap_init(0, 0x00000);
    bitmap_clear();

    gotoxy(0,29);
    textcolor(YELLOW);
    printf("press a key ...");

    while(!fgetc()) {
        bitmap_line(modr16u(rand(),320,0), modr16u(rand(),320,0), modr16u(rand(),200,0), modr16u(rand(),200,0), rand()&255);
    };

    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    gotoxy(0,26);
    printf("here you see all the colors possible.\n");

    gotoxy(0,29);
    textcolor(YELLOW);
    printf("press a key ...");

    word x = 0;
    byte color = 0;
    while(!fgetc()) {
        bitmap_line(x, x, 0, 199, color);
        color++;
        x++;
        if(x>319) x=0;
    };
}
