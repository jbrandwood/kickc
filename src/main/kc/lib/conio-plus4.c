// Commodore Plus/4 / 16 / 116 conio.h implementation
#include <conio.h>
#include <plus4.h>

// The screen width
#define CONIO_WIDTH 40
// The screen height
#define CONIO_HEIGHT 25
// The text screen address
char * const CONIO_SCREEN_TEXT = DEFAULT_SCREEN;
// The color screen address
char * const CONIO_SCREEN_COLORS = DEFAULT_COLORRAM;
// The default text color
const char CONIO_TEXTCOLOR_DEFAULT = 0;

// Use the shared CMB flat memory implementation
#include "conio-cbm-shared.c"

// Initializer for conio.h on PLUS4
#pragma constructor_for(conio_plus4_init, cputc, clrscr, cscroll)

// Set initial cursor position
void conio_plus4_init() {
    // Position cursor at current line
    char * const BASIC_CURSOR_LINE = (char*)0xCD;
    char line = *BASIC_CURSOR_LINE;
    if(line>=CONIO_HEIGHT) line=CONIO_HEIGHT-1;
    gotoxy(0, line);
}

// Return true if there's a key waiting, return false if not
unsigned char kbhit (void) {
    // Read all keyboard matrix rows
    KEYBOARD_PORT->PORT = 0x00;
    // Write to the keyboard input to latch the matrix column values
    // TODO: Currently inline ASM is used to prevent the ASM optimizer from removing the load of the KEYBOARD_INPUT.
    // TED->KEYBOARD_INPUT = 0;
    asm { sta $ff08 }
    // Read the keyboard input
    return ~TED->KEYBOARD_INPUT;
}

// Set the color for the background. The old color setting is returned.
unsigned char bgcolor(unsigned char color) {
    char old = TED->BG_COLOR;
    TED->BG_COLOR = color;
    return old;
}

// Set the color for the border. The old color setting is returned.
unsigned char bordercolor(unsigned char color) {
    char old = TED->BORDER_COLOR;
    TED->BORDER_COLOR = color;
    return old;
}
