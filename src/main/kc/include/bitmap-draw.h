// Plot and line drawing routines for HIRES bitmaps
// Currently it can only plot on the first 256 x-positions.

// Initialize the bitmap plotter tables for a specific bitmap
void bitmap_init(byte* bitmap);

// Clear all graphics on the bitmap
void bitmap_clear();

void bitmap_plot(byte x, byte y);

// Draw a line on the bitmap
void bitmap_line(byte x0, byte x1, byte y0, byte y1);