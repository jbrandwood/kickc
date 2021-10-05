// MEGA65 conio.h implementation
#include <conio.h>
#include <mega65.h>
#include <6502.h>

// The screen width
#ifdef __MEGA65_C64__
#define CONIO_WIDTH 40
#else
#define CONIO_WIDTH 80
#endif

// The screen height
#define CONIO_HEIGHT 25
// The text screen address
#ifndef CONIO_SCREEN_TEXT
#define CONIO_SCREEN_TEXT DEFAULT_SCREEN
#endif
// The color screen address
#ifndef CONIO_SCREEN_COLORS
#define CONIO_SCREEN_COLORS COLORRAM
#endif
// The default text color
#ifndef CONIO_TEXTCOLOR_DEFAULT
#define CONIO_TEXTCOLOR_DEFAULT LIGHT_BLUE
#endif

// Use the shared CBM flat memory implementation
#include "conio-cbm-shared.c"

// Initializer for conio.h on MEGA65
#pragma constructor_for(conio_mega65_init, cputc, clrscr, cscroll)

// Enable 2K Color ROM
void conio_mega65_init() {
    // Disable BASIC/KERNAL interrupts
    SEI();
    // Map memory to BANK 0 : 0x00XXXX - giving access to I/O
    memoryRemap(0,0,0);
    // Enable the VIC 4
    *IO_KEY = 0x47;
    *IO_KEY = 0x53;
    // Enable 2K Color RAM
    *IO_BANK |= CRAM2K;
    // Position cursor at current line
    char * const BASIC_CURSOR_LINE = (char*)0xeb;
    char line = *BASIC_CURSOR_LINE+1;
    if(line>=CONIO_HEIGHT) line=CONIO_HEIGHT-1;
    gotoxy(0, line);
}

// Return true if there's a key waiting, return false if not
unsigned char kbhit (void) {
    // CIA#1 Port A: keyboard matrix columns and joystick #2
    char* const CIA1_PORT_A = (char*)0xdc00;
    // CIA#1 Port B: keyboard matrix rows and joystick #1.
    char* const CIA1_PORT_B = (char*)0xdc01;
    // Map CIA I/O
    *IO_BANK &= ~CRAM2K;
    // Read keyboard
    *CIA1_PORT_A = 0;
    unsigned char hit = ~*CIA1_PORT_B;
    // Map 2K Color RAM
    *IO_BANK |= CRAM2K;
    return hit;
}

// Set the color for the background. The old color setting is returned.
unsigned char bgcolor(unsigned char color) {
    // The background color register address
    char * const CONIO_BGCOLOR = (char*)0xd021;
    char old = *CONIO_BGCOLOR;
    *CONIO_BGCOLOR = color;
    return old;
}

// Set the color for the border. The old color setting is returned.
unsigned char bordercolor(unsigned char color) {
    // The border color register address
    char * const CONIO_BORDERCOLOR = (char*)0xd020;
    char old = *CONIO_BORDERCOLOR;
    *CONIO_BORDERCOLOR = color;
    return old;
}
