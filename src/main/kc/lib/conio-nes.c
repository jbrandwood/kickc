// Conio.h implementation for NES
// No support for colors so far
// Scrolling is done by moving all chars in the PPU memory - very slowly!
#include <conio.h>
#include <nes.h>

// The screen width
#define CONIO_WIDTH 32
// The screen height
#define CONIO_HEIGHT 30
// The number of bytes on the screen
#define CONIO_BYTES CONIO_HEIGHT*CONIO_WIDTH
// The text screen address
char * const CONIO_SCREEN_TEXT = PPU_NAME_TABLE_0;

// Return true if there's any key pressed, return false if not
unsigned char kbhit (void) {
    return ~readJoy1();
}

// Set the color for the background. The old color setting is returned.
unsigned char bgcolor(unsigned char color) {
    return 0;
}

// Set the color for the border. The old color setting is returned.
unsigned char bordercolor(unsigned char color) {
    return 0;
}

// The current cursor x-position
__ma char conio_cursor_x = 0;
// The current cursor y-position
__ma char conio_cursor_y = 0;
// The current text cursor line start
__ma char *conio_line_text = CONIO_SCREEN_TEXT;
// Is a cursor shown when waiting for input (0: no, other: yes)
__ma char conio_display_cursor = 0;
// Is scrolling enabled when outputting beyond the end of the screen (1: yes, 0: no).
// If disabled the cursor just moves back to (0,0) instead
__ma char conio_scroll_enable = 1;

// clears the screen and moves the cursor to the upper left-hand corner of the screen.
void clrscr(void) {
    ppuDataFill(CONIO_SCREEN_TEXT, ' ', 0x3c0);
    conio_cursor_x = 0;
    conio_cursor_y = 0;
    conio_line_text = CONIO_SCREEN_TEXT;
}

// Set the cursor to the specified position
void gotoxy(unsigned char x, unsigned char y) {
    if(y>CONIO_HEIGHT) y = 0;
    if(x>=CONIO_WIDTH) x = 0;
    conio_cursor_x = x;
    conio_cursor_y = y;
    unsigned int line_offset = (unsigned int)y*CONIO_WIDTH;
    conio_line_text = CONIO_SCREEN_TEXT + line_offset;
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
        ppuDataSet(conio_line_text+conio_cursor_x, c);
        if(++conio_cursor_x==CONIO_WIDTH)
            cputln();
    }
}

// Print a newline
void cputln() {
    conio_line_text +=  CONIO_WIDTH;
    conio_cursor_x = 0;
    conio_cursor_y++;
    cscroll();
}

#pragma data_seg(GameRam)
// Buffer used for scrolling the NES screen
char conio_cscroll_buffer[CONIO_WIDTH];
#pragma data_seg(Data)

// Scroll the entire screen if the cursor is beyond the last line
void cscroll() {
    if(conio_cursor_y==CONIO_HEIGHT) {
        if(conio_scroll_enable) {
            // Scroll lines up
            char* line1 = CONIO_SCREEN_TEXT;
            char* line2 = CONIO_SCREEN_TEXT+CONIO_WIDTH;
            for(char y=0;y<CONIO_HEIGHT-1;y++) {
                ppuDataFetch(conio_cscroll_buffer, line2, CONIO_WIDTH);
                ppuDataTransfer(line1, conio_cscroll_buffer, CONIO_WIDTH);
                line1 += CONIO_WIDTH;
                line2 += CONIO_WIDTH;
            }
            // Fill last line with space
            ppuDataFill(CONIO_SCREEN_TEXT+CONIO_BYTES-CONIO_WIDTH, ' ', CONIO_WIDTH);
            conio_line_text -= CONIO_WIDTH;
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

// Set the color for text output. The old color setting is returned.
unsigned char textcolor(unsigned char color) {
    return 0;
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
// If onoff is 0, scrolling is disabled and the cursor instead moves to (0,0)
// The function returns the old scroll setting.
unsigned char scroll(unsigned char onoff) {
    char old = conio_scroll_enable;
    conio_scroll_enable = onoff;
    return old;
}
