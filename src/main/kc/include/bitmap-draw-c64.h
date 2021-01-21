// Plot and line drawing routines for HIRES bitmaps
// Currently it can only plot on the first 256 x-positions.

// Initialize the bitmap plotter tables for a specific bitmap
void bitmap_init(char* bitmap);

// Clear all graphics on the bitmap
void bitmap_clear();

void bitmap_plot(char x, char y);

// Draw a line on the bitmap
void bitmap_line(char x0, char x1, char y0, char y1);