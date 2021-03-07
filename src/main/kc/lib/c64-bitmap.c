// Simple single-color (320x200) bitmap routines
#include <c64-bitmap.h>
#include <string.h>

// The adddress of the bitmap screen (used for colors)
char* bitmap_screen;
// The adddress of the bitmap graphics (used for pixels)
char* bitmap_gfx;

// Tables for the plotter - initialized by calling bitmap_init();
const char bitmap_plot_ylo[256];
const char bitmap_plot_yhi[256];
const char bitmap_plot_bit[256];

// Initialize bitmap plotting tables
void bitmap_init(char* gfx, char* screen) {
    bitmap_gfx = gfx;
    bitmap_screen = screen;
    char bits = $80;
    for(char x : 0..255) {
        bitmap_plot_bit[x] = bits;
        bits >>= 1;
        if(bits==0) {
          bits = $80;
        }
    }
    char* yoffs = gfx;
    for(char y : 0..255) {
        bitmap_plot_ylo[y] = y&$7 | <yoffs;
        bitmap_plot_yhi[y] = >yoffs;
        if((y&$7)==7) {
            yoffs = yoffs + 40*8;
        }
    }
}

// Clear all graphics on the bitmap
// bgcol - the background color to fill the screen with
// fgcol - the foreground color to fill the screen with
void bitmap_clear(char bgcol, char fgcol) {
    char col = fgcol*0x10 + bgcol;
    memset(bitmap_screen, col, 1000uw);
    memset(bitmap_gfx, 0, 8000uw);
}

// Plot a single dot in the bitmap
void bitmap_plot(unsigned int x, char y) {
    char* plotter = (char*) { bitmap_plot_yhi[y], bitmap_plot_ylo[y] };
    plotter += ( x & $fff8 );
    *plotter |= bitmap_plot_bit[<x];
}

// Draw a line on the bitmap using bresenhams algorithm
void bitmap_line(unsigned int x1, unsigned int y1, unsigned int x2, unsigned int y2) {
    unsigned int x = x1;
    unsigned int y = y1;
    unsigned int dx = abs_u16(x2-x1);
    unsigned int dy = abs_u16(y2-y1);
    if(dx==0 && dy==0) {
        bitmap_plot(x,(char)y);
        return;
    }
    unsigned int sx = sgn_u16(x2-x1);
    unsigned int sy = sgn_u16(y2-y1);
    if(dx > dy) {
        // X is the driver
        unsigned int e = dy/2;
        do  {
            bitmap_plot(x,(char)y);
            x += sx;
            e += dy;
            if(dx < e) {
                y += sy;
                e -= dx;
            }
        } while (x != x2);
    } else {
        // Y is the driver
        unsigned int e = dx/2;
        do  {
            bitmap_plot(x,(char)y);
            y += sy;
            e += dx;
            if(dy<e) {
                x += sx;
                e -= dy;
            }
        } while (y != y2);
    }
    bitmap_plot(x,(char)y);
}

// Get the absolute value of a 16-bit unsigned number treated as a signed number.
unsigned int abs_u16(unsigned int w) {
    if(>w&0x80) {
        return -w;
    } else {
        return w;
    }
}

// Get the sign of a 16-bit unsigned number treated as a signed number.
// Returns unsigned -1 if the number is
unsigned int sgn_u16(unsigned int w) {
    if(>w&0x80) {
        return -1;
    } else {
        return 1;
    }
}

