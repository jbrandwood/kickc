// Plot and line drawing routines for HIRES bitmaps
// Currently it can only plot on the first 256 x-positions.

// Initialize the bitmap plotter tables for a specific bitmap
void bitmap_init(byte layer, word address);

// Clear all graphics on the bitmap
void bitmap_clear();

void bitmap_plot(word x, word y);

// Draw a line on the bitmap
void bitmap_line(word x0, word x1, word y0, word y1);