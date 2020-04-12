// Provides provide console input/output
// Implements similar functions as conio.h from CC65 for compatibility
// See https://github.com/cc65/cc65/blob/master/include/conio.h
#include <conio.h>

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
// The screen width
const char CONIO_WIDTH = 40;
// The screen height
const char CONIO_HEIGHT = 25;

// The default text color
const char CONIO_TEXTCOLOR_DEFAULT = 0xe;

// The current cursor x-position
char conio_cursor_x = 0;
// The current cursor y-position
char conio_cursor_y = 0;
// The current cursor address
char *conio_cursor_text = CONIO_SCREEN_TEXT;
// The current cursor address
char *conio_cursor_color = CONIO_SCREEN_COLORS;
// The current text color
char conio_textcolor = CONIO_TEXTCOLOR_DEFAULT;
// Is a cursor whown when waiting for input (0: no, other: yes)
char conio_display_cursor = 0;

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
    if(x>=CONIO_WIDTH) x = 0;
    if(y>=CONIO_HEIGHT) y = 0;
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

// Return the X position of the cursor
inline unsigned char wherex(void) {
    return conio_cursor_x;
}

// Return the Y position of the cursor
inline unsigned char wherey(void) {
    return conio_cursor_y;
}

// Output one character at the current cursor position
// Moves the cursor forward
void cputc(char c) {
    if(c=='\n') {
        gotoxy(0, conio_cursor_y+1);
    } else {
        *conio_cursor_text++ = c;
        *conio_cursor_color++ = conio_textcolor;
        if(++conio_cursor_x==CONIO_WIDTH) {
            conio_cursor_x = 0;
            if(++conio_cursor_y==CONIO_HEIGHT) {
                gotoxy(0,0);
            }
        }
    }
}

// Move cursor and output one character
// Same as "gotoxy (x, y); cputc (c);"
void cputcxy(unsigned char x, unsigned char y, char c) {
    gotoxy(x, y);
    cputc(c);
}


// Output a NUL-terminated string at the current cursor position
void cputs(const char* s) {
    char c;
    while(c=*s++)
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
unsigned char bordercolor(unsigned char color)
{
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