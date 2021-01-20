// Example program for the Commander X16.
// Demonstrates the usage of the VERA tile map modes and layering.

// Author: Sven Van de Velde

// The default layer of the CX16 is layer 1, but the tiles are written on layer 0.

// An explanation is given how this mode is organized, and how the tiles display and coloring works.
// Pälette offsets are explained also.

#include <conio.h>
#include <printf.h>
#include <bitmap-draw.h>
#include <stdlib.h>

char lines_x[] = { 60, 80, 110, 80, 60, 40, 10, 40, 60 };
char lines_y[] = { 10, 40, 60, 80, 110, 80, 60, 40, 10 };
char lines_cnt = 8;

void lines() {
    for(char l=0; l<lines_cnt;l++) {
        bitmap_line(lines_x[l], lines_x[l+1], lines_y[l], lines_y[l+1]);
    }
}
void main() {

    vera_layer_mode_bitmap(0, (dword)0x04000, 320, 1);

    screenlayer(1);
    textcolor(RED);
    bgcolor(BLACK);
    clrscr();

    gotoxy(0,20);
    printf("vera in bitmap mode,\n");
    printf("color depth 8 bits per pixel.\n");

    printf("in this mode, it is possible to display\n\n");
    printf("graphics in 256 colors.\n\n");

    vera_layer_show(0);

    bitmap_init(0, 0x4000);
    bitmap_clear();

    while(!kbhit()) {
        bitmap_line(rand()&$00FF, rand()&$00FF, rand()&$007F, rand()&$007F);
    };

    screenlayer(1);
    textcolor(WHITE);
    bgcolor(BLUE);
    clrscr();

}
