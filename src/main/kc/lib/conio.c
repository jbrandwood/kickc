// Provides provide console input/output
// Implements similar functions as conio.h from CC65 for compatibility
// See https://github.com/cc65/cc65/blob/master/include/conio.h
//
// Currently only the C64 platform is supported
#include <string.h>
#include <conio.h>

// The screen width
#define CONIO_WIDTH 40
// The screen height
#define CONIO_HEIGHT 25
// The screen bytes
#define CONIO_BYTES CONIO_HEIGHT*CONIO_WIDTH

// The text screen address
char * const CONIO_SCREEN_TEXT = 0x0400;
// The color screen address
char * const CONIO_SCREEN_COLORS = 0xd800;
// The background color register address
char * const CONIO_BGCOLOR = 0xd021;
// The border color register address
char * const CONIO_BORDERCOLOR = 0xd020;
// CIA#1 Port A: keyboard matrix columns and joystick #2
char* const CONIO_CIA1_PORT_A = 0xdc00;
// CIA#1 Port B: keyboard matrix rows and joystick #1.
char* const CONIO_CIA1_PORT_B = 0xdc01;

// The default text color
const char CONIO_TEXTCOLOR_DEFAULT = 0xe;

// The current cursor x-position
__ma char conio_cursor_x = 0;
// The current cursor y-position
__ma char conio_cursor_y = 0;
// The current cursor address
__ma char *conio_cursor_text = CONIO_SCREEN_TEXT;
// The current cursor address
__ma char *conio_cursor_color = CONIO_SCREEN_COLORS;
// The current text color
__ma char conio_textcolor = CONIO_TEXTCOLOR_DEFAULT;
// Is a cursor whown when waiting for input (0: no, other: yes)
__ma char conio_display_cursor = 0;
// Is scrolling enabled when outputting beyond the end of the screen (1: yes, 0: no).
// If disabled the cursor just moves back to (0,0) instead
__ma char conio_scroll_enable = 1;

// clears the screen and moves the cursor to the upper left-hand corner of the screen.
void clrscr(void) {
    char* line_text = CONIO_SCREEN_TEXT;
    char* line_cols = CONIO_SCREEN_COLORS;
    for( char l=0;l<CONIO_HEIGHT; l++ ) {
        for( char c=0;c<CONIO_WIDTH; c++ ) {
            line_text[c] = ' ';
            line_cols[c] = conio_textcolor;
        }
        line_text += CONIO_WIDTH;
        line_cols += CONIO_WIDTH;
    }
    conio_cursor_x = 0;
    conio_cursor_y = 0;
    conio_cursor_text = CONIO_SCREEN_TEXT;
    conio_cursor_color = CONIO_SCREEN_COLORS;
}

// Set the cursor to the specified position
void gotoxy(unsigned char x, unsigned char y) {
    if(y>CONIO_HEIGHT) y = 0;
    if(x>=CONIO_WIDTH) x = 0;
    conio_cursor_x = x;
    conio_cursor_y = y;
    unsigned int offset = (unsigned int)y*CONIO_WIDTH + x;
    conio_cursor_text = CONIO_SCREEN_TEXT + offset;
    conio_cursor_color = CONIO_SCREEN_COLORS + offset;
}

// Return the current screen size.
void screensize(unsigned char* x, unsigned char* y) {
    *x = CONIO_WIDTH;
    *y = CONIO_HEIGHT;
}

// Return the current screen size X width.
inline char screensizex() {
    return CONIO_WIDTH;
}

// Return the current screen size Y height.
inline char screensizey() {
    return CONIO_HEIGHT;
}

// Return the X position of the cursor
inline unsigned char wherex(void) {
    return conio_cursor_x;
}

// Return the Y position of the cursor
inline unsigned char wherey(void) {
    return conio_cursor_y;
}

// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
void cputc(char c) {
    if(c=='\n') {
        cputln();
    } else {
        *conio_cursor_text++ = c;
        *conio_cursor_color++ = conio_textcolor;
        if(++conio_cursor_x==CONIO_WIDTH) {
            conio_cursor_x = 0;
            ++conio_cursor_y;
            cscroll();
        }
    }
}

// Print a newline
void cputln() {
    conio_cursor_text =  conio_cursor_text - conio_cursor_x + CONIO_WIDTH;
    conio_cursor_color = conio_cursor_color - conio_cursor_x + CONIO_WIDTH;
    conio_cursor_x = 0;
    conio_cursor_y++;
    cscroll();
}

// Scroll the entire screen if the cursor is beyond the last line
void cscroll() {
    if(conio_cursor_y==CONIO_HEIGHT) {
        if(conio_scroll_enable) {
            memcpy(CONIO_SCREEN_TEXT, CONIO_SCREEN_TEXT+CONIO_WIDTH, CONIO_BYTES-CONIO_WIDTH);
            memcpy(CONIO_SCREEN_COLORS, CONIO_SCREEN_COLORS+CONIO_WIDTH, CONIO_BYTES-CONIO_WIDTH);
            memset(CONIO_SCREEN_TEXT+CONIO_BYTES-CONIO_WIDTH, ' ', CONIO_WIDTH);
            memset(CONIO_SCREEN_COLORS+CONIO_BYTES-CONIO_WIDTH, conio_textcolor, CONIO_WIDTH);
            conio_cursor_text = conio_cursor_text-CONIO_WIDTH;
            conio_cursor_color = conio_cursor_color-CONIO_WIDTH;
            conio_cursor_y--;
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
void cputcxy(unsigned char x, unsigned char y, char c) {
    gotoxy(x, y);
    cputc(c);
}

// Move cursor and output a NUL-terminated string
// Same as "gotoxy (x, y); puts (s);"
void cputsxy(unsigned char x, unsigned char y, const char* s) {
    gotoxy(x, y);
    cputs(s);
}

// Output a horizontal line with the given length starting at the current cursor position.
void chline(unsigned char length) {
    for(char i=0;i<length;i++)
        cputc(CH_HLINE);
}

// Output a vertical line with the given length at the current cursor position.
void cvline (unsigned char length) {
    char x = conio_cursor_x;
    char y = conio_cursor_y;
    for(char i=0;i<length;i++) {
        cputc(CH_VLINE);
        gotoxy(x, ++y);
    }
}

// Move cursor and output a vertical line with the given length
// Same as "gotoxy (x, y); cvline (length);"
void cvlinexy(unsigned char x, unsigned char y, unsigned char length) {
    gotoxy(x,y);
    cvline(length);
}


// Set the color for text output. The old color setting is returned.
unsigned char textcolor(unsigned char color) {
    char old = conio_textcolor;
    conio_textcolor = color;
    return old;
}

// Set the color for the background. The old color setting is returned.
unsigned char bgcolor(unsigned char color) {
    char old = *CONIO_BGCOLOR;
    *CONIO_BGCOLOR = color;
    return old;
}

// Set the color for the border. The old color setting is returned.
unsigned char bordercolor(unsigned char color) {
    char old = *CONIO_BORDERCOLOR;
    *CONIO_BORDERCOLOR = color;
    return old;
}

// Return true if there's a key waiting, return false if not
unsigned char kbhit (void) {
    *CONIO_CIA1_PORT_A = 0;
    return ~*CONIO_CIA1_PORT_B;
}

// If onoff is 1, a cursor is displayed when waiting for keyboard input.
// If onoff is 0, the cursor is hidden when waiting for keyboard input.
// The function returns the old cursor setting.
unsigned char cursor(unsigned char onoff) {
    char old = conio_display_cursor;
    conio_display_cursor = onoff;
    return old;
}

// If onoff is 1, scrolling is enabled when outputting past the end of the screen
// If onoff is 1, scrolling is disabled and the cursor instead moves to (0,0)
// The function returns the old scroll setting.
unsigned char scroll(unsigned char onoff) {
    char old = conio_scroll_enable;
    conio_scroll_enable = onoff;
    return old;
}