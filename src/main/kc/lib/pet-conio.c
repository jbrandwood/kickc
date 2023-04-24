// Commodore 64 conio.h implementation
#include <kernal.h>
#include <conio.h>
#include <pet.h>

// The screen width
#define CONIO_WIDTH 80
// The screen height
#define CONIO_HEIGHT 25
// The text screen address
#ifndef CONIO_SCREEN_TEXT
#define CONIO_SCREEN_TEXT DEFAULT_SCREEN
#endif

// The default text color
#ifndef CONIO_TEXTCOLOR_DEFAULT
#define CONIO_TEXTCOLOR_DEFAULT WHITE
#endif

// Use the shared CMB flat memory implementation
#include "conio-cbm-shared.c"

// Initializer for conio.h on C64
#pragma constructor_for(conio_cpet_init, cputc, clrscr, cscroll)

// Set initial cursor position
void conio_cpet_init() {
    // // Position cursor at current line
    // char * const BASIC_CURSOR_LINE = (char*)0xD6;
    // char line = *BASIC_CURSOR_LINE;
    // if(line>=CONIO_HEIGHT) line=CONIO_HEIGHT-1;
    // gotoxy(0, line);
}

// Return true if there's a key waiting, return false if not
unsigned char kbhit (void) {
    // // CIA#1 Port A: keyboard matrix columns and joystick #2
    // char* const CIA1_PORT_A = (char*)0xdc00;
    // // CIA#1 Port B: keyboard matrix rows and joystick #1.
    // char* const CIA1_PORT_B = (char*)0xdc01;
    // *CIA1_PORT_A = 0;
    // return ~*CIA1_PORT_B;
    return 0;
}

// Set the color for the background. The old color setting is returned.
unsigned char bgcolor(unsigned char color) {
    return 0;
}

// Set the color for the border. The old color setting is returned.
unsigned char bordercolor(unsigned char color) {
    return 0;
}

// Get a charakter from the keyboard and return it.
unsigned char getch() {
    return cbm_k_getin();
}
