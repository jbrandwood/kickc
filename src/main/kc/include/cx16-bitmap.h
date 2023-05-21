/// @file
/// Plot and line drawing routines for HIRES bitmaps
///
/// Currently it can only plot on the first 256 x-positions.

/// Initialize the bitmap plotter tables for a specific bitmap
void bitmap_init(unsigned char layer, unsigned char bank, unsigned int offset);

/// Clear all graphics on the bitmap
void bitmap_clear();

void bitmap_plot(word x, word y, byte c);

/// Draw a line on the bitmap
void bitmap_line(word x0, word x1, word y0, word y1, byte c);