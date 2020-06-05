// Provides provide console input/output
// Implements similar functions as conio.h from CC65 for compatibility
// See https://github.com/cc65/cc65/blob/master/include/conio.h
//
// Currently C64/PLUS4/VIC20 platforms are supported

// clears the screen and moves the cursor to the upper left-hand corner of the screen.
void clrscr(void);

// Set the cursor to the specified position
void gotoxy(unsigned char x, unsigned char y);

// Return the X position of the cursor
unsigned char wherex(void);

// Return the Y position of the cursor
unsigned char wherey(void);

// Return the current screen size.
void screensize(unsigned char* x, unsigned char* y);

// Return the current screen size X width.
char screensizex();

// Return the current screen size Y height.
char screensizey();

// Output one character at the current cursor position. Scroll the screen if needed.
void cputc(char c);

// Move teh cursor to the start of the next line. Scroll the screen if needed.
void cputln();

// Move cursor and output one character
// Same as "gotoxy (x, y); cputc (c);"
void cputcxy(unsigned char x, unsigned char y, char c);

// Output a NUL-terminated string at the current cursor position
void cputs(const char* s);

// Move cursor and output a NUL-terminated string
// Same as "gotoxy (x, y); puts (s);"
void cputsxy(unsigned char x, unsigned char y, const char* s);

// Set the color for text output. The old color setting is returned.
unsigned char textcolor(unsigned char color);

// Set the color for the background. The old color setting is returned.
unsigned char bgcolor(unsigned char color);

// Set the color for the border. The old color setting is returned.
unsigned char bordercolor(unsigned char color);

// Return true if there's a key waiting, return false if not
unsigned char kbhit (void);

// If onoff is 1, a cursor is displayed when waiting for keyboard input.
// If onoff is 0, the cursor is hidden when waiting for keyboard input.
// The function returns the old cursor setting.
unsigned char cursor(unsigned char onoff);

// If onoff is 1, scrolling is enabled when outputting past the end of the screen
// If onoff is 1, scrolling is disabled and the cursor instead moves to (0,0)
// The function returns the old scroll setting.
unsigned char scroll(unsigned char onoff);