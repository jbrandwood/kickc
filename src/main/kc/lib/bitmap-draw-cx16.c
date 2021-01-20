// Plot and line drawing routines for HIRES bitmaps
// Currently it can only plot on the first 256 x-positions.

#include <bitmap-draw.h>
#include <veralib.h>

// Tables for the plotter - initialized by calling bitmap_draw_init();
const word bitmap_plot_x[640];
const word bitmap_plot_y[480];
const byte bitmap_plot_bit[640];

__ma word bitmap_address = 0;
__ma byte bitmap_layer = 0;

// Initialize the bitmap plotter tables for a specific bitmap
void bitmap_init(byte layer, word address) {
    bitmap_address = address;
    bitmap_layer = layer;
    byte color_depth = vera_layer_get_color_depth(bitmap_layer);
    word vdeltas[4] = {0, 80, 40, 20};
    byte hscale = vera_display_get_hscale(); // Returns 1 when 640 and 2 when 320.


    byte bit = $80;
    for(word x : 0..639) {
        if(color_depth==1) bitmap_plot_x[x] = (x >> 3);
        if(color_depth==2) bitmap_plot_x[x] = (x >> 2);
        if(color_depth==4) bitmap_plot_x[x] = (x >> 1);
        if(color_depth==8) {}
        bitmap_plot_bit[x] = bit;
        bit >>= 1;
        if(bit==0)
           bit=$80;
    }

    // This sets the right delta to skip a whole line based on the scale, depending on the color depth.
    word vdelta = vdeltas[hscale];
    // We start at the bitmap address; The plot_y contains the bitmap address embedded so we know where a line starts.
    word yoffs = bitmap_address;
    for(word y : 0..479) {
        bitmap_plot_y[y] = yoffs;
        yoffs = yoffs + vdelta;
    }
}

// Clear all graphics on the bitmap
void bitmap_clear() {
    memset_vram(0,bitmap_address,0,80*60*8);
}

void bitmap_plot(word x, word y) {
    // Needs unsigned int arrays arranged as two underlying char arrays to allow char* plotter_x = plot_x[x]; - and eventually - char* plotter = plot_x[x] + plot_y[y];
    word plotter = bitmap_plot_x[x]+bitmap_plot_y[y];
    vera_vram_bank_offset(0,(word)plotter,VERA_INC_0);
    *VERA_DATA0 = *VERA_DATA0 | bitmap_plot_bit[x];
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


