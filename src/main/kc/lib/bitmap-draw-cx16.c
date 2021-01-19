// Plot and line drawing routines for HIRES bitmaps
// Currently it can only plot on the first 256 x-positions.

#include <bitmap-draw.h>
#include <veralib.h>

// Tables for the plotter - initialized by calling bitmap_draw_init();
const word bitmap_plot_y[640];
const byte bitmap_plot_bit[8];

word bitmap = 0;
// Initialize the bitmap plotter tables for a specific bitmap
void bitmap_init(word bitmap_address) {
    bitmap = bitmap_address;
    word yoffs = $0;
    byte bit = $80;
    for(word x : 0..7) {
        bitmap_plot_bit[x] = bit;
        bit >>= 1;
    }
    for(word y : 0..600) {
        bitmap_plot_y[y] = yoffs;
        yoffs = yoffs + 80;
    }
}

// Clear all graphics on the bitmap
void bitmap_clear() {
    word bitmap_address = bitmap;
    for( word y: 0..600 ) {
        for( word x: 0..40 ) {
            vera_vram_bank_offset(0,(word)bitmap_address,VERA_INC_0);
            *VERA_DATA0 = 0;
            bitmap_address++;
        }
    }
}

void bitmap_plot(word x, word y) {
    // Needs unsigned int arrays arranged as two underlying char arrays to allow char* plotter_x = plot_x[x]; - and eventually - char* plotter = plot_x[x] + plot_y[y];
    word plotter_x = x>>3;
    word plotter_y = bitmap_plot_y[y];

    word plotter = bitmap+plotter_x+plotter_y;
    vera_vram_bank_offset(0,(word)plotter,VERA_INC_0);
    *VERA_DATA0 = *VERA_DATA0 | bitmap_plot_bit[x&$07];
}


// Draw a line on the bitmap
void bitmap_line(word x0, word x1, word y0, word y1) {
    word xd;
    word yd;
    if(x0<x1) {
        xd = x1-x0;
        if(y0<y1) {
            yd = y1-y0;
            if(yd<xd) {
                bitmap_line_xdyi(x0, y0, x1, xd, yd);
            } else {
                bitmap_line_ydxi(y0, x0, y1, yd, xd);
            }
        } else {
            yd = y0-y1;
            if(yd<xd) {
                bitmap_line_xdyd(x0, y0, x1, xd, yd);
            } else {
                bitmap_line_ydxd(y1, x1, y0, yd, xd);
            }
        }
    } else {
        xd = x0-x1;
        if(y0<y1) {
            yd = y1-y0;
            if(yd<xd) {
                bitmap_line_xdyd(x1, y1, x0, xd, yd);
            } else {
                bitmap_line_ydxd(y0, x0, y1, yd, xd);
            }
        } else {
            yd = y0-y1;
            if(yd<xd) {
                bitmap_line_xdyi(x1, y1, x0, xd, yd);
            } else {
                bitmap_line_ydxi(y1, x1, y0, yd, xd);
            }
        }
    }
}

void bitmap_line_xdyi(word x, word y, word x1, word xd, word yd) {
  word e = yd>>1;
  do  {
      bitmap_plot(x,y);
      x++;
      e = e+yd;
      if(xd<e) {
          y++;
          e = e - xd;
      }
  } while (x!=(x1+1));
}

void bitmap_line_xdyd(word x, word y, word x1, word xd, word yd) {
  word e = yd>>1;
  do  {
      bitmap_plot(x,y);
      x++;
      e = e+yd;
      if(xd<e) {
          y--;
          e = e - xd;
      }
  } while (x!=(x1+1));
}

void bitmap_line_ydxi(word y, word x, word y1, word yd, word xd) {
  word e = xd>>1;
  do  {
      bitmap_plot(x,y);
      y++;
      e = e+xd;
      if(yd<e) {
          x++;
          e = e - yd;
      }
  } while (y!=(y1+1));
}

void bitmap_line_ydxd(word y, word x, word y1, word yd, word xd) {
  word e = xd>>1;
  do  {
      bitmap_plot(x,y);
      y = y++;
      e = e+xd;
      if(yd<e) {
          x--;
          e = e - yd;
      }
  } while (y!=(y1+1));
}


