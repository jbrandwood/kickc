// Simple single-color (320x200) bitmap routines
#include <string.h>

// Initialize bitmap plotting tables
void bitmap_init(byte* gfx, byte* screen);

// Clear all graphics on the bitmap
// bgcol - the background color to fill the screen with
// fgcol - the foreground color to fill the screen with
void bitmap_clear(byte bgcol, byte fgcol);

// Plot a single dot in the bitmap
void bitmap_plot(word x, byte y);

// Draw a line on the bitmap using bresenhams algorithm
void bitmap_line(word x1, word y1, word x2, word y2);

// Get the absolute value of a 16-bit unsigned number treated as a signed number.
word abs_u16(word w);

// Get the sign of a 16-bit unsigned number treated as a signed number.
// Returns unsigned -1 if the number is
word sgn_u16(word w);
