// Provides provide simple horisontal/vertical lines routines on top of conio.h
// For compatibility with CC65 https://github.com/cc65/cc65/blob/master/include/conio.h
#include <conio-lines.h>

// Output a horizontal line with the given length starting at the current cursor position.
void chline(unsigned char length) {
    for(char i=0;i<length;i++)
        cputc(CH_HLINE);
}

// Output a vertical line with the given length at the current cursor position.
void cvline(unsigned char length) {
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
