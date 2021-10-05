// Commodore VIC 20 conio.h implementation
#include <conio.h>
#include <vic20.h>

// The screen width
#define CONIO_WIDTH 22
// The screen height
#define CONIO_HEIGHT 23
// The text screen address
#ifndef CONIO_SCREEN_TEXT
#define CONIO_SCREEN_TEXT DEFAULT_SCREEN
#endif
// The color screen address
#ifndef CONIO_SCREEN_COLORS
#define CONIO_SCREEN_COLORS DEFAULT_COLORRAM
#endif
// The default text color
#ifndef CONIO_TEXTCOLOR_DEFAULT
#define CONIO_TEXTCOLOR_DEFAULT BLUE
#endif

// Use the shared CMB flat memory implementation
#include "conio-cbm-shared.c"

// Initializer for conio.h on VIC20
#pragma constructor_for(conio_vic20_init, cputc, clrscr, cscroll)

// Set initial cursor position
void conio_vic20_init() {
    // Position cursor at current line
    char * const BASIC_CURSOR_LINE = (char*)0xD6;
    char line = *BASIC_CURSOR_LINE;
    if(line>=CONIO_HEIGHT) line=CONIO_HEIGHT-1;
    gotoxy(0, line);
}

// Return true if there's a key waiting, return false if not
unsigned char kbhit (void) {
    // Read all keyboard matrix rows
    VIA2->PORT_B = 0x00;
    // Read the keyboard input
    return ~VIA2->PORT_A;
}

// Set the color for the background. The old color setting is returned.
unsigned char bgcolor(unsigned char color) {
    char old = VIC->BORDER_BACKGROUND_COLOR;
    VIC->BORDER_BACKGROUND_COLOR = old&0x0f|(color<<4);
    return old>>4;
}

// Set the color for the border. The old color setting is returned.
unsigned char bordercolor(unsigned char color) {
    char old = VIC->BORDER_BACKGROUND_COLOR;
    VIC->BORDER_BACKGROUND_COLOR = old&0xf8|color;
    return old&0x07;
}
