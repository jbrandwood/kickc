// CX16 conio.h implementation
#include <conio.h>
#include <cx16.h>

// The screen width
#define CONIO_WIDTH conio_screen_width
// The screen height
#define CONIO_HEIGHT conio_screen_height
// The text screen address
char * const CONIO_SCREEN_TEXT = DEFAULT_SCREEN;
// The color screen address
char * const CONIO_SCREEN_COLORS = COLORRAM;
// The default text color
const char CONIO_TEXTCOLOR_DEFAULT = WHITE;
// The default back color
const char CONIO_BACKCOLOR_DEFAULT = BLUE;

// Initializer for conio.h on X16 Commander.
#pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)

// Set initial cursor position
void conio_x16_init() {
    // Position cursor at current line
    char * const BASIC_CURSOR_LINE = 0xD6;
    char line = *BASIC_CURSOR_LINE;
    screensize( &conio_screen_width, &conio_screen_height );
    if(line>=CONIO_HEIGHT) line=CONIO_HEIGHT-1;
    gotoxy(0, line);
}

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
__ma unsigned byte conio_cursor_x = 0;
// The current cursor y-position
__ma unsigned byte conio_cursor_y = 0;
// The current text cursor line start
__ma unsigned byte *conio_line_text = CONIO_SCREEN_TEXT;
// The current color cursor line start
__ma unsigned byte *conio_line_color = CONIO_SCREEN_COLORS;
// The current text color
__ma unsigned byte conio_textcolor = CONIO_TEXTCOLOR_DEFAULT;
__ma unsigned byte conio_backcolor = CONIO_BACKCOLOR_DEFAULT; // only for text 16 color mode;
// Is a cursor whown when waiting for input (0: no, other: yes)
__ma unsigned byte conio_display_cursor = 0;
// Is scrolling enabled when outputting beyond the end of the screen (1: yes, 0: no).
// If disabled the cursor just moves back to (0,0) instead
__ma unsigned byte conio_scroll_enable = 1;
// Variable holding the screen width;
__ma unsigned byte conio_screen_width = 0;
// Variable holding the screen height;
__ma unsigned byte conio_screen_height = 0;

// clears the screen and moves the cursor to the upper left-hand corner of the screen.
void clrscr(void) {
    char* line_text = CONIO_SCREEN_TEXT;
    char* line_cols = CONIO_SCREEN_COLORS;
    unsigned int conio_width = VERA_L1_CONFIG_WIDTH[ ( (*VERA_L1_CONFIG) & VERA_L1_CONFIG_WIDTH_MASK ) >> 4 ];
    unsigned int conio_height = VERA_L1_CONFIG_HEIGHT[ ( (*VERA_L1_CONFIG) & VERA_L1_CONFIG_HEIGHT_MASK ) >> 6 ];
    char color = ( conio_backcolor << 4 ) | conio_textcolor;
    for( char l=0;l<conio_height; l++ ) {
        char *ch = line_text;
        // Select DATA0
        *VERA_CTRL &= ~VERA_ADDRSEL;
        // Set address
        *VERA_ADDRX_L = <ch;
        *VERA_ADDRX_M = >ch;
        *VERA_ADDRX_H = VERA_INC_1;
        for( char c=0;c<conio_width; c++ ) {
            // Set data
            *VERA_DATA0 = ' ';
            *VERA_DATA0 = color;
            //vpoke(0,ch++,' ');
            //vpoke(0,ch++,0x61);
            //line_text[c] = ' ';
            //line_cols[c] = conio_textcolor;
        }
        line_text += 256;
        line_cols += 256;
    }
    conio_cursor_x = 0;
    conio_cursor_y = 0;
    conio_line_text = CONIO_SCREEN_TEXT;
    conio_line_color = CONIO_SCREEN_COLORS;
}

// Set the cursor to the specified position
void gotoxy(unsigned byte x, unsigned byte y) {
    if(y>CONIO_HEIGHT) y = 0;
    if(x>=CONIO_WIDTH) x = 0;
    conio_cursor_x = x;
    conio_cursor_y = y;
    unsigned int line_offset = (unsigned int)y << 8;
    conio_line_text = CONIO_SCREEN_TEXT + line_offset;
    conio_line_color = CONIO_SCREEN_COLORS + line_offset;
}

// Return the current screen size.
void screensize(unsigned byte* x, unsigned byte* y) {
    // VERA returns in VERA_DC_HSCALE the value of 128 when 80 columns is used in text mode,
    // and the value of 64 when 40 columns is used in text mode.
    // Basically, 40 columns mode in the VERA is a double scan mode.
    // Same for the VERA_DC_VSCALE mode.
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
    return conio_cursor_x;
}

// Return the Y position of the cursor
inline unsigned byte wherey(void) {
    return conio_cursor_y;
}

// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
void cputc(char c) {
    char color = ( conio_backcolor << 4 ) | conio_textcolor;
    if(c=='\n') {
        cputln();
    } else {
        // Select DATA0
        *VERA_CTRL &= ~VERA_ADDRSEL;
        // Set address
        char lx = conio_cursor_x << 1;
        *VERA_ADDRX_L = <(conio_line_text+lx);
        *VERA_ADDRX_M = >(conio_line_text+lx);
        *VERA_ADDRX_H = VERA_INC_1;
        *VERA_DATA0 = c;
        *VERA_DATA0 = color;

        //conio_line_text[conio_cursor_x] = c;
        //conio_line_color[conio_cursor_x] = conio_textcolor;
        if(++conio_cursor_x==CONIO_WIDTH)
            cputln();
    }
}

// Print a newline
void cputln() {
    //conio_line_text +=  CONIO_WIDTH;
    conio_line_text +=  256;
    conio_line_color += CONIO_WIDTH;
    conio_cursor_x = 0;
    conio_cursor_y++;
    cscroll();
}

void clearline() {
    // Select DATA0
    *VERA_CTRL &= ~VERA_ADDRSEL;
    // Set address
    *VERA_ADDRX_L = <conio_line_text;
    *VERA_ADDRX_M = >conio_line_text;
    *VERA_ADDRX_H = VERA_INC_1;
    char color = ( conio_backcolor << 4 ) | conio_textcolor;
    for( unsigned int c=0;c<CONIO_WIDTH; c++ ) {
        // Set data
        *VERA_DATA0 = ' ';
        *VERA_DATA0 = color;
    }
}

// Insert a new line, and scroll the lower part of the screen down.
void insertdown() {
    unsigned byte cy = CONIO_HEIGHT - conio_cursor_y;
    cy -= 1;
    unsigned byte width = CONIO_WIDTH * 2;
    for(unsigned byte i=cy; i>0; i--) {
        unsigned int line = (conio_cursor_y + i - 1) << 8;
        unsigned char* start = CONIO_SCREEN_TEXT + line;
        vram_to_vram(width, 0, start, VERA_INC_1, 0, start+256, VERA_INC_1);
    }
    clearline();
}

// Insert a new line, and scroll the upper part of the screen up.
void insertup() {
    unsigned byte cy = conio_cursor_y;
    unsigned byte width = CONIO_WIDTH * 2;
    for(unsigned byte i=1; i<=cy; i++) {
        unsigned int line = (i-1) << 8;
        unsigned char* start = CONIO_SCREEN_TEXT + line;
        vram_to_vram(width, 0, start+256, VERA_INC_1, 0, start, VERA_INC_1);
    }
    clearline();
}

// Scroll the entire screen if the cursor is beyond the last line
void cscroll() {
    if(conio_cursor_y>=CONIO_HEIGHT) {
        if(conio_scroll_enable) {
            insertup();
            gotoxy( 0, CONIO_HEIGHT-1);
        } else {
            gotoxy(0,0);
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

// Set the color for text output. The old color setting is returned.
unsigned byte textcolor(unsigned byte color) {
    char old = conio_textcolor;
    conio_textcolor = color;
    return old;
}

// Set the color for back output. The old color setting is returned.
unsigned byte backcolor(unsigned byte color) {
    char old = conio_backcolor;
    conio_backcolor = color;
    return old;
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
    char old = conio_scroll_enable;
    conio_scroll_enable = onoff;
    return old;
}
