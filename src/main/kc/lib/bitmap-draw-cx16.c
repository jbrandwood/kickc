// Plot and line drawing routines for HIRES bitmaps
// Currently it can only plot on the first 256 x-positions.

#include <bitmap-draw.h>
#include <veralib.h>
#include <multiply.h>

// Tables for the plotter - initialized by calling bitmap_draw_init();
const word bitmap_plot_x[640];
const dword bitmap_plot_y[480];
const byte bitmap_plot_bit[640];

__ma dword bitmap_address = 0;
__ma byte bitmap_layer = 0;

const word hdeltas[4] = {0, 80, 40, 20};
const word vdeltas[4] = {0, 60, 30, 15};
const byte bitmasks[5] = {0, $80, $C0, $F0, $FF};

// Initialize the bitmap plotter tables for a specific bitmap
void bitmap_init(byte layer, dword address) {
    bitmap_address = address;
    bitmap_layer = layer;
    byte color_depth = vera_layer_get_color_depth(bitmap_layer);
    byte hscale = vera_display_get_hscale(); // Returns 1 when 640 and 2 when 320.
    byte vscale = vera_display_get_vscale(); // Returns 1 when 480 and 2 when 240.
    byte bitmask = bitmasks[color_depth];

    for(word x : 0..639) {
        if(color_depth==1) {
            bitmap_plot_x[x] = (x >> 3);
            bitmap_plot_bit[x] = bitmask;
            bitmask >>= 1;
        }
        if(color_depth==2) {
            bitmap_plot_x[x] = (x >> 2);
            bitmap_plot_bit[x] = bitmask;
            bitmask >>= 2;
        }
        if(color_depth==4) {
            bitmap_plot_x[x] = (x >> 1);
            bitmap_plot_bit[x] = bitmask;
            bitmask >>= 4;
        }
        if(color_depth==8) {
            bitmap_plot_x[x] = x;
            bitmap_plot_bit[x] = bitmask;
        }
        if(bitmask==0) {
           bitmask = bitmasks[color_depth];
        }
    }

    // This sets the right delta to skip a whole line based on the scale, depending on the color depth.
    word hdelta = hdeltas[hscale];
    if(color_depth==8) hdelta = hdelta << 3;
    if(color_depth==4) hdelta = hdelta << 2;
    if(color_depth==2) hdelta = hdelta << 1;

    // We start at the bitmap address; The plot_y contains the bitmap address embedded so we know where a line starts.
    dword yoffs = bitmap_address;
    for(word y : 0..479) {
        //bitmap_plot_y[y] = yoffs;
        yoffs = yoffs + hdelta;
    }
}

// Clear all graphics on the bitmap
void bitmap_clear() {
    byte color_depth = vera_layer_get_color_depth(bitmap_layer);
    byte bitmask = bitmasks[color_depth];
    byte hscale = vera_display_get_hscale(); // Returns 1 when 640 and 2 when 320.
    byte vscale = vera_display_get_vscale(); // Returns 1 when 480 and 2 when 240.
    word count = hdeltas[hscale];
    if(color_depth==8) count = count << 6;
    if(color_depth==4) count = count << 5;
    if(color_depth==2) count = count << 4;
    if(color_depth==1) count = count << 3;
    word lines = vera_display_get_height();
    dword address = bitmap_address;
    word hdelta = hdeltas[hscale];
    if(color_depth==8) hdelta = hdelta << 3;
    if(color_depth==4) hdelta = hdelta << 2;
    if(color_depth==2) hdelta = hdelta << 1;
    for(word line=0; line<lines; line++) {
        memset_vram_address(address,0,count);
        address+=hdelta;
    }
}

void bitmap_plot(word x, word y) {
    // Needs unsigned int arrays arranged as two underlying char arrays to allow char* plotter_x = plot_x[x]; - and eventually - char* plotter = plot_x[x] + plot_y[y];
    dword plot_x = bitmap_plot_x[x];
    dword plot_y = bitmap_plot_y[y];
    dword plotter = plot_x+plot_y;
    vera_vram_address0(plotter,VERA_INC_0);
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


