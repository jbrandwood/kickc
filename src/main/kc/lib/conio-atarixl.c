// Atari XL conio.h implementation
// Created by Mark Fisher @mark.j.fisher @fenrock https://atariage.com/forums/profile/73491-fenrock/
// https://gitlab.com/mark.j.fisher/kickc/-/tree/conio-atari
#include <string.h>
#include <conio.h>
#include <atari-xl.h>

// The screen width
#define CONIO_WIDTH 40
// The screen height
#define CONIO_HEIGHT 24

// The current reverse value indicator. Values 0 or 0x80 for reverse text
__ma char conio_reverse_value = 0;

// The current cursor enable flag. 1 = on, 0 = off.
__ma char conio_display_cursor = 1;

// The current scroll enable flag. 1 = on, 0 = off.
__ma char conio_scroll_enable = 1;

// Move cursor and output one character
// Same as "gotoxy (x, y); cputc (c);"
void cputcxy(unsigned char x, unsigned char y, char c) {
	gotoxy(x, y);
	cputc(c);
}

// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
void cputc(char c) {
	char screenCode;
	if (c == '\r') { // 0x0d, CR = just set the cursor x value to 0
		*COLCRS = 0;
		setcursor();
	} else if(c == '\n' || c == 0x9b) { // 0x0a LF, or atascii EOL
		*COLCRS = 0;
		newline();
	} else {
		putchar(convertToScreenCode(&c));
		(*COLCRS)++;
		if (*COLCRS == CONIO_WIDTH) {
			*COLCRS = 0;
			newline();
		} else {
			setcursor();
		}
	}
}

// Puts a character to the screen a the current location. Uses internal screencode. Deals with storing the old cursor value
void putchar(unsigned char code) {
	**OLDADR = *OLDCHR;
	char * loc = cursorLocation();
	char newChar = code | conio_reverse_value;
	*loc = newChar;
	*OLDCHR = newChar;
	setcursor();
}

// Output a NUL-terminated string at the current cursor position
void cputs(const char* s) {
	char c;
	while (c = *s++) {
		cputc(c);
	}
}

// Move cursor and output a NUL-terminated string
// Same as "gotoxy (x, y); puts (s);"
void cputsxy(unsigned char x, unsigned char y, const char* s) {
    gotoxy(x, y);
    cputs(s);
}

// Return a pointer to the location of the cursor
char * cursorLocation() {
	return *SAVMSC + (word)(*ROWCRS)*CONIO_WIDTH + *COLCRS;
}

void newline() {
	if ((*ROWCRS)++ == CONIO_HEIGHT) {
		if (conio_scroll_enable == 1) {
			// first hide the current screen cursor, so it doesn't scroll, but only if it is on
			if (conio_display_cursor == 1) {
				**OLDADR ^= 0x80;
			}
			// move screen up 1 line
			char * start = *SAVMSC;
			memcpy(start, start + CONIO_WIDTH, CONIO_WIDTH * 23);
			memset(start + CONIO_WIDTH * 23, 0x00, CONIO_WIDTH);
			*ROWCRS = CONIO_HEIGHT - 1;
		} else {
			gotoxy(0, 0);
		}
	}
	setcursor();
}

// Handles cursor movement, displaying it if required, and inverting character it is over if there is one (and enabled)
void setcursor() {
	// save the current oldchr into oldadr
	**OLDADR = *OLDCHR;
	// work out the new location for oldadr based on new column/row
	char * loc = cursorLocation();
	char c = *loc;
	*OLDCHR = c;
	*OLDADR = loc;
	if (conio_display_cursor == 0) {
		// cursor is off, don't affect the character at all, but do turn off cursor
		*CRSINH = 1;
	} else {
		// cursor is on, so invert the inverse bit and turn cursor on
		*CRSINH = 0;
		c = c ^ 0x80;
	}
	**OLDADR = c;
}

// Print a newline
void cputln() {
	*COLCRS = 0;
	newline();
}

// Set the cursor to the specified position
void gotoxy(unsigned char x, unsigned char y) {
	*COLCRS = x;
	*ROWCRS = y;
	setcursor();
}

// Sets reverse mode for text. 1 enables reverse, 0 disables. Returns the old value.
unsigned char revers(unsigned char onoff) {
	char old = conio_reverse_value;
	if (onoff == 0) conio_reverse_value = 0; else conio_reverse_value = 0x80;
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

// clears the screen and moves the cursor to the upper left-hand corner of the screen.
void clrscr() {
	// Fill entire screen with spaces
	memset(*SAVMSC, 0x00, CONIO_WIDTH * CONIO_HEIGHT); // 0x00 is screencode for space character
	// set the old character to a space so the cursor doesn't reappear at the last position it was at
	*OLDCHR = 0x00;
	gotoxy(0,0);
}

// If onoff is 1, a cursor is displayed when any text is output.
// If onoff is 0, the cursor is hidden instead.
unsigned char cursor(unsigned char onoff) {
	// this just updates internal cursor flag value, doesn't update CRSINH
	// onoff: 0 => cursor off, 1 => cursor on
	// CRSINH is opposite to this, 0 == ON, 1 == OFF
	char oldValue = conio_display_cursor;
	conio_display_cursor = onoff;
	return oldValue;
}

// Return the X position of the cursor
unsigned char wherex() {
	return (*COLCRS & 0xff);
}

// Return the Y position of the cursor
unsigned char wherey() {
	return *ROWCRS;
}

// Return the current screen size.
void screensize(unsigned char *x, unsigned char *y) {
	*x = CONIO_WIDTH;
	*y = CONIO_HEIGHT;
}

// Return the current screen size X width.
char screensizex() {
	return CONIO_WIDTH;
}

// Return the current screen size Y height.
char screensizey() {
	return CONIO_HEIGHT;
}

// Return 1 if there's a key waiting, return 0 if not
unsigned char kbhit() {
	if (*CH == 0xff) return 0; else return 1;
}

// Clears the key waiting buffer.
inline void clrkb() {
	*CH = 0xff;
}

// Set the color for the text. The old color setting is returned.
unsigned char textcolor(unsigned char color) {
    char old = *COLOR1;
    *COLOR1 = color;
    return old;
}

// Set the color for the background. The old color setting is returned.
unsigned char bgcolor(unsigned char color) {
    char old = *COLOR2;
    *COLOR2 = color;
    return old;
}

// Set the color for the border. The old color setting is returned.
unsigned char bordercolor(unsigned char color) {
    char old = *COLOR4;
    *COLOR4 = color;
    return old;
}

// Convert an atascii character to its screen code representation. Requires 1 page lookup table generated below.
inline unsigned char convertToScreenCode(unsigned char* v) {
	return rawmap[*v];
}

// create a static table to map char value to screen value
// use KickAsm functions to create a table of code -> screen code values, using cc65 algorithm
char rawmap[0x100] = kickasm {{
	.var ht = Hashtable().put(0,64, 1,0, 2,32, 3,96) // the table for converting bit 6,7 into ora value
	.for(var i=0; i<256; i++) {
		.var idx = (i & 0x60) / 32
		.var mask = i & 0x9f
		.byte mask | ht.get(idx)
	}
}};

