// Commodore VIC 20 conio.h implementation
#include <conio.h>
#include <vic20.h>

// The screen width
#define CONIO_WIDTH 22
// The screen height
#define CONIO_HEIGHT 23
// The text screen address
char * const CONIO_SCREEN_TEXT = DEFAULT_SCREEN;
// The color screen address
char * const CONIO_SCREEN_COLORS = DEFAULT_COLORRAM;
// The default text color
const char CONIO_TEXTCOLOR_DEFAULT = BLUE;

// Use the shared CMB flat memory implementation
#include "conio-cbm-shared.c"

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
