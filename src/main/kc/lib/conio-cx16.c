// CX16 conio.h implementation
#include <conio.h>
#include <cx16.h>
#include <cx16-veralib.h>

// The screen width
#define CONIO_WIDTH conio_screen_width
// The screen height
#define CONIO_HEIGHT conio_screen_height
// The text screen base address, which is a 16:0 bit value in VERA VRAM.
// That is 128KB addressable space, thus 17 bits in total.
// CONIO_SCREEN_TEXT contains bits 15:0 of the address.
// CONIO_SCREEN_BANK contains bit 16, the the 64K memory bank in VERA VRAM (the upper 17th bit).
// !!! note that these values are not const for the cx16!
// This conio implements the two layers of VERA, which can be layer 0 or layer 1.
// Configuring conio to output to a different layer, will change these fields to the address base
// configured using VERA_L0_MAPBASE = 0x9f2e or VERA_L1_MAPBASE = 0x9f35.
// Using the function setscreenlayer(layer) will re-calculate using CONIO_SCREEN_TEXT and CONIO_SCREEN_BASE
// based on the values of VERA_L0_MAPBASE or VERA_L1_MAPBASE, mapping the base address of the selected layer.
// The function setscreenlayermapbase(layer,mapbase) allows to configure bit 16:9 of the
// mapbase address of the time map in VRAM of the selected layer VERA_L0_MAPBASE or VERA_L1_MAPBASE.
char* CONIO_SCREEN_TEXT = DEFAULT_SCREEN;
char CONIO_SCREEN_BANK = 0; // Default screen of the CX16 emulator uses memory bank 0 for text.
// The default text color
#ifndef CONIO_TEXTCOLOR_DEFAULT
#define CONIO_TEXTCOLOR_DEFAULT WHITE
#endif
// The default back color
#ifndef CONIO_BACKCOLOR_DEFAULT
#define CONIO_BACKCOLOR_DEFAULT BLUE
#endif


// This requires the following constants to be defined
// - CONIO_WIDTH - The screen width
// - CONIO_HEIGHT - The screen height
// - CONIO_SCREEN_TEXT - The text screen address
// - CONIO_SCREEN_COLORS - The color screen address
// - CONIO_TEXTCOLOR_DEFAULT - The default text color

#include <string.h>

// The number of bytes on the screen
#define CONIO_BYTES CONIO_HEIGHT*CONIO_WIDTH

// The current cursor x-position
unsigned byte conio_cursor_x[2] = {0,0};
// The current cursor y-position
unsigned byte conio_cursor_y[2] = {0,0};
// The current text cursor line start
unsigned word conio_line_text[2] = {0x0000,0x0000};
// Is a cursor whown when waiting for input (0: no, other: yes)
__ma unsigned byte conio_display_cursor = 0;
// Is scrolling enabled when outputting beyond the end of the screen (1: yes, 0: no).
// If disabled the cursor just moves back to (0,0) instead
unsigned byte conio_scroll_enable[2] = {1,1};
// Variable holding the screen width;
__ma unsigned byte conio_screen_width = 0;
// Variable holding the screen height;
__ma unsigned byte conio_screen_height = 0;
// Variable holding the screen layer on the VERA card with which conio interacts;
__ma unsigned byte conio_screen_layer = 1;

// Variables holding the current map width and map height of the layer.
__ma word conio_width = 0;
__ma word conio_height = 0;
__ma byte conio_rowshift = 0;
__ma word conio_rowskip = 0;

// Initializer for conio.h on X16 Commander.
#pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)

// Set initial cursor position
void conio_x16_init() {
    // Position cursor at current line
    char * const BASIC_CURSOR_LINE = (char*)0xD6;
    char line = *BASIC_CURSOR_LINE;
    vera_layer_mode_text(1,(dword)0x00000,(dword)0x0F800,128,64,8,8,16);
    screensize(&conio_screen_width, &conio_screen_height);
    screenlayer(1);
    vera_layer_set_textcolor(1, WHITE);
    vera_layer_set_backcolor(1, BLUE);
    vera_layer_set_mapbase(0,0x20);
    vera_layer_set_mapbase(1,0x00);
    if(line>=CONIO_HEIGHT) line=CONIO_HEIGHT-1;
    gotoxy(0, line);
}

// Return true if there's a key waiting, return false if not
unsigned char kbhit(void) {

    char ch = 0;
    char* const chptr = &ch;

    char* const IN_DEV = (char*)$028A;        // Current input device number
    char* const GETIN  = (char*)$FFE4;        // CBM GETIN API

    kickasm(uses chptr, uses IN_DEV, uses GETIN) {{

        jsr _kbhit
        bne L3

        jmp continue1

        .var via1 = $9f60                  //VIA#1
        .var d1pra = via1+1

    _kbhit:
        ldy     d1pra       // The count of keys pressed is stored in RAM bank 0.
        stz     d1pra       // Set d1pra to zero to access RAM bank 0.
        lda     $A00A       // Get number of characters from this address in the ROM of the CX16 (ROM 38).
        sty     d1pra       // Set d1pra to previous value.
        rts

    L3:
        ldy     IN_DEV          // Save current input device
        stz     IN_DEV          // Keyboard
        phy
        jsr     GETIN           // Read char, and return in .A
        ply
        sta     chptr           // Store the character read in ch
        sty     IN_DEV          // Restore input device
        ldx     #>$0000
        rts

    continue1:
        nop
     }}

    return ch;
}

// clears the screen and moves the cursor to the upper left-hand corner of the screen.
void clrscr(void) {
    char* line_text = CONIO_SCREEN_TEXT;
    char color = ( vera_layer_get_backcolor(conio_screen_layer) << 4 ) | vera_layer_get_textcolor(conio_screen_layer);
    for( char l=0;l<conio_height; l++ ) {
        char *ch = line_text;
        // Select DATA0
        *VERA_CTRL &= ~VERA_ADDRSEL;
        // Set address
        *VERA_ADDRX_L = BYTE0(ch);
        *VERA_ADDRX_M = BYTE1(ch);
        *VERA_ADDRX_H = CONIO_SCREEN_BANK | VERA_INC_1;
        for( char c=0;c<conio_width; c++ ) {
            *VERA_DATA0 = ' ';
            *VERA_DATA0 = color;
        }
        line_text += conio_rowskip;
    }
    conio_cursor_x[conio_screen_layer] = 0;
    conio_cursor_y[conio_screen_layer] = 0;
    conio_line_text[conio_screen_layer] = 0;
}

// Set the cursor to the specified position
void gotoxy(unsigned byte x, unsigned byte y) {
    if(y>CONIO_HEIGHT) y = 0;
    if(x>=CONIO_WIDTH) x = 0;
    conio_cursor_x[conio_screen_layer] = x;
    conio_cursor_y[conio_screen_layer] = y;
    unsigned int line_offset = (unsigned int)y << conio_rowshift;
    conio_line_text[conio_screen_layer] = line_offset;
}

// Return the current screen size.
void screensize(unsigned byte* x, unsigned byte* y) {
    // VERA returns in VERA_DC_HSCALE the value of 128 when 80 columns is used in text mode,
    // and the value of 64 when 40 columns is used in text mode.
    // Basically, 40 columns mode in the VERA is a double scan mode.
    // Same for the VERA_DC_VSCALE mode, but then the subdivision is 60 or 30 rows.
    // I still need to test the other modes, but this will suffice for now for the pure text modes.
    char hscale = (*VERA_DC_HSCALE) >> 7;
    *x = 40 << hscale;
    char vscale = (*VERA_DC_VSCALE) >> 7;
    *y = 30 << vscale;
    //printf("%u, %u\n", *x, *y);
}

// Return the current screen size X width.
inline unsigned byte screensizex() {
    return conio_screen_width;
}

// Return the current screen size Y height.
inline unsigned byte screensizey() {
    return conio_screen_height;
}

// Return the X position of the cursor
inline unsigned byte wherex(void) {
    return conio_cursor_x[conio_screen_layer];
}

// Return the Y position of the cursor
inline unsigned byte wherey(void) {
    return conio_cursor_y[conio_screen_layer];
}

// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
void cputc(char c) {
    char color = vera_layer_get_color( conio_screen_layer);
    char* conio_addr = CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer];

    conio_addr += conio_cursor_x[conio_screen_layer] << 1;
    if(c=='\n') {
        cputln();
    } else {
        // Select DATA0
        *VERA_CTRL &= ~VERA_ADDRSEL;
        // Set address
        *VERA_ADDRX_L = BYTE0(conio_addr);
        *VERA_ADDRX_M = BYTE1(conio_addr);
        *VERA_ADDRX_H = CONIO_SCREEN_BANK | VERA_INC_1;
        *VERA_DATA0 = c;
        *VERA_DATA0 = color;

        conio_cursor_x[conio_screen_layer]++;
        byte scroll_enable = conio_scroll_enable[conio_screen_layer];
        if(scroll_enable) {
            if(conio_cursor_x[conio_screen_layer] == CONIO_WIDTH)
                cputln();
        } else {
            if((unsigned int)conio_cursor_x[conio_screen_layer] == conio_width)
                cputln();
        }
    }
}

// Print a newline
void cputln() {
    // TODO: This needs to be optimized! other variations don't compile because of sections not available!
    word temp = conio_line_text[conio_screen_layer];
    temp += conio_rowskip;
    conio_line_text[conio_screen_layer] = temp;
    conio_cursor_x[conio_screen_layer] = 0;
    conio_cursor_y[conio_screen_layer]++;
    cscroll();
}

void clearline() {
    // Select DATA0
    *VERA_CTRL &= ~VERA_ADDRSEL;
    // Set address
    byte* addr = CONIO_SCREEN_TEXT + conio_line_text[conio_screen_layer];
    *VERA_ADDRX_L = BYTE0(addr);
    *VERA_ADDRX_M = BYTE1(addr);
    *VERA_ADDRX_H = VERA_INC_1;
    char color = vera_layer_get_color( conio_screen_layer);
    for( unsigned int c=0;c<CONIO_WIDTH; c++ ) {
        // Set data
        *VERA_DATA0 = ' ';
        *VERA_DATA0 = color;
    }
    conio_cursor_x[conio_screen_layer] = 0;
}

// Insert a new line, and scroll the lower part of the screen down.
void insertdown() {
    unsigned byte cy = CONIO_HEIGHT - conio_cursor_y[conio_screen_layer];
    cy -= 1;
    unsigned byte width = CONIO_WIDTH * 2;
    for(unsigned byte i=cy; i>0; i--) {
        unsigned int line = (conio_cursor_y[conio_screen_layer] + i - 1) << conio_rowshift;
        unsigned char* start = CONIO_SCREEN_TEXT + line;
        memcpy_in_vram(0, start+conio_rowskip, VERA_INC_1, 0, start, VERA_INC_1, width);
    }
    clearline();
}

// Insert a new line, and scroll the upper part of the screen up.
void insertup() {
    unsigned byte cy = conio_cursor_y[conio_screen_layer];
    unsigned byte width = CONIO_WIDTH * 2;
    for(unsigned byte i=1; i<=cy; i++) {
        unsigned int line = (i-1) << conio_rowshift;
        unsigned char* start = CONIO_SCREEN_TEXT + line;
        memcpy_in_vram(0, start, VERA_INC_1,  0, start+conio_rowskip, VERA_INC_1, width);
    }
    clearline();
}

// Scroll the entire screen if the cursor is beyond the last line
void cscroll() {
    if(conio_cursor_y[conio_screen_layer]>=CONIO_HEIGHT) {
        if(conio_scroll_enable[conio_screen_layer]) {
            insertup();
            gotoxy( 0, CONIO_HEIGHT-1);
        } else {
            if(conio_cursor_y[conio_screen_layer]>=conio_height) {
               //gotoxy(0,0);
            }
        }
    }
}


// Output a NUL-terminated string at the current cursor position
void cputs(const char* s) {
    char c;
    while(c=*s++)
        cputc(c);
}

// Move cursor and output one character
// Same as "gotoxy (x, y); cputc (c);"
void cputcxy(unsigned byte x, unsigned byte y, char c) {
    gotoxy(x, y);
    cputc(c);
}

// Move cursor and output a NUL-terminated string
// Same as "gotoxy (x, y); puts (s);"
void cputsxy(unsigned byte x, unsigned byte y, const char* s) {
    gotoxy(x, y);
    cputs(s);
}

// If onoff is 1, a cursor is displayed when waiting for keyboard input.
// If onoff is 0, the cursor is hidden when waiting for keyboard input.
// The function returns the old cursor setting.
unsigned byte cursor(unsigned byte onoff) {
    char old = conio_display_cursor;
    conio_display_cursor = onoff;
    return old;
}

// If onoff is 1, scrolling is enabled when outputting past the end of the screen
// If onoff is 0, scrolling is disabled and the cursor instead moves to (0,0)
// The function returns the old scroll setting.
unsigned byte scroll(unsigned byte onoff) {
    char old = conio_scroll_enable[conio_screen_layer];
    conio_scroll_enable[conio_screen_layer] = onoff;
    return old;
}

// --- Defined in cx16.c and cx16-vera.h ---

// --- layer management in VERA ---

// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
void screenlayer(unsigned byte layer) {
    conio_screen_layer = layer;
    CONIO_SCREEN_BANK = vera_layer_get_mapbase_bank(conio_screen_layer);
    CONIO_SCREEN_TEXT = (char*)vera_layer_get_mapbase_offset(conio_screen_layer);
    conio_width = vera_layer_get_width(conio_screen_layer);
    conio_rowshift = vera_layer_get_rowshift(conio_screen_layer);
    conio_rowskip = vera_layer_get_rowskip(conio_screen_layer);
    conio_height = vera_layer_get_height(conio_screen_layer);
}


// Set the front color for text output. The old front text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
inline char textcolor(char color) {
    return vera_layer_set_textcolor(conio_screen_layer, color);
}

// Set the back color for text output. The old back text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
inline char bgcolor(char color) {
    return vera_layer_set_backcolor(conio_screen_layer, color);
}

// Set the color for the border. The old color setting is returned.
char bordercolor(unsigned char color) {
    // The border color register address
    char old = *VERA_DC_BORDER;
    *VERA_DC_BORDER = color;
    return old;
}

