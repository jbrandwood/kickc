// Simple single-color (320x200) bitmap routines
#include <string.h>

// Initialize bitmap plotting tables
void bitmap_init(char* gfx, char* screen);

// Clear all graphics on the bitmap
// bgcol - the background color to fill the screen with
// fgcol - the foreground color to fill the screen with
void bitmap_clear(char bgcol, char fgcol);

// Plot a single dot in the bitmap
void bitmap_plot(unsigned int x, char y);

// Draw a line on the bitmap using bresenhams algorithm
void bitmap_line(unsigned int x1, unsigned int y1, unsigned int x2, unsigned int y2);

// Get the absolute value of a 16-bit unsigned number treated as a signed number.
unsigned int abs_u16(unsigned int w);

// Get the sign of a 16-bit unsigned number treated as a signed number.
// Returns unsigned -1 if the number is
unsigned int sgn_u16(unsigned int w);
