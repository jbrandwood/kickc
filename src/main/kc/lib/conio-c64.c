// Commodore 64 conio.h implementation
#include <conio.h>
#include <c64.h>

// The screen width
#define CONIO_WIDTH 40
// The screen height
#define CONIO_HEIGHT 25
// The text screen address
char * const CONIO_SCREEN_TEXT = DEFAULT_SCREEN;
// The color screen address
char * const CONIO_SCREEN_COLORS = COLORRAM;
// The default text color
const char CONIO_TEXTCOLOR_DEFAULT = LIGHT_BLUE;

// Use the shared CMB flat memory implementation
#include "conio-cbm-shared.c"

// Return true if there's a key waiting, return false if not
unsigned char kbhit (void) {
    // CIA#1 Port A: keyboard matrix columns and joystick #2
    char* const CIA1_PORT_A = 0xdc00;
    // CIA#1 Port B: keyboard matrix rows and joystick #1.
    char* const CIA1_PORT_B = 0xdc01;
    *CIA1_PORT_A = 0;
    return ~*CIA1_PORT_B;
}

// Set the color for the background. The old color setting is returned.
unsigned char bgcolor(unsigned char color) {
    // The background color register address
    char * const CONIO_BGCOLOR = 0xd021;
    char old = *CONIO_BGCOLOR;
    *CONIO_BGCOLOR = color;
    return old;
}

// Set the color for the border. The old color setting is returned.
unsigned char bordercolor(unsigned char color) {
    // The border color register address
    char * const CONIO_BORDERCOLOR = 0xd020;
    char old = *CONIO_BORDERCOLOR;
    *CONIO_BORDERCOLOR = color;
    return old;
}
