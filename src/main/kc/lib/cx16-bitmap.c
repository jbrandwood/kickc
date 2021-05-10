// Plot and line drawing routines for HIRES bitmaps
// Currently it can only plot on the first 256 x-positions.

#include <cx16-bitmap.h>
#include <cx16-veralib.h>
#include <multiply.h>

// Tables for the plotter - initialized by calling bitmap_draw_init();
const word  __bitmap_plot_x[640];
const dword __bitmap_plot_y[480];
const byte  __bitmap_plot_bitmask[640];
const byte  __bitmap_plot_bitshift[640];

__ma dword __bitmap_address = 0;
__ma byte __bitmap_layer = 0;
__ma byte __bitmap_hscale = 0;
__ma byte __bitmap_vscale = 0;
__ma byte __bitmap_color_depth = 0;

word hdeltas[16] = {
    0, 80, 40, 20,    // 1 BPP
    0, 160, 80, 40,   // 2 BPP
    0, 320, 160, 80,  // 4 BPP
    0, 640, 320, 160  // 8 BPP
    };
const word vdeltas[4] = {0, 480, 240, 160};
const byte bitmasks[5] = {$80, $C0, $F0, $FF};
const signed byte bitshifts[5] = {7, 6, 4, 0};


// Initialize the bitmap plotter tables for a specific bitmap
void bitmap_init(byte layer, dword address) {
    __bitmap_address = address;
    __bitmap_layer = layer;
    __bitmap_color_depth = vera_layer_get_color_depth(__bitmap_layer);
    __bitmap_hscale = vera_display_get_hscale(); // Returns 1 when 640 and 2 when 320.
    __bitmap_vscale = vera_display_get_vscale(); // Returns 1 when 480 and 2 when 240.

    byte bitmask = bitmasks[__bitmap_color_depth];
    signed byte bitshift = bitshifts[__bitmap_color_depth];

    for(word x : 0..639) {
        // 1 BPP
        if(__bitmap_color_depth==0) {
            __bitmap_plot_x[x] = (x >> 3);
            __bitmap_plot_bitmask[x] = bitmask;
            __bitmap_plot_bitshift[x] = (byte)bitshift;
            bitshift -= 1;
            bitmask >>= 1;
        }
        // 2 BPP
        if(__bitmap_color_depth==1) {
            __bitmap_plot_x[x] = (x >> 2);
            __bitmap_plot_bitmask[x] = bitmask;
            __bitmap_plot_bitshift[x] = (byte)bitshift;
            bitshift -= 2;
            bitmask >>= 2;
        }
        // 4 BPP
        if(__bitmap_color_depth==2) {
            __bitmap_plot_x[x] = (x >> 1);
            __bitmap_plot_bitmask[x] = bitmask;
            __bitmap_plot_bitshift[x] = (byte)bitshift;
            bitshift -= 4;
            bitmask >>= 4;
        }
        // 8 BPP
        if(__bitmap_color_depth==3) {
            __bitmap_plot_x[x] = x;
            __bitmap_plot_bitmask[x] = bitmask;
            __bitmap_plot_bitshift[x] = (byte)bitshift;
        }
        if(bitshift<0) {
            bitshift = bitshifts[__bitmap_color_depth];
        }
        if(bitmask==0) {
            bitmask = bitmasks[__bitmap_color_depth];
        }
    }

    // This sets the right delta to skip a whole line based on the scale, depending on the color depth.
    word hdelta = hdeltas[(__bitmap_color_depth<<2)+__bitmap_hscale];
    // We start at the bitmap address; The plot_y contains the bitmap address embedded so we know where a line starts.
    dword yoffs = __bitmap_address;
    for(word y : 0..479) {
        __bitmap_plot_y[y] = yoffs;
        yoffs = yoffs + hdelta;
    }
}

// Clear all graphics on the bitmap
void bitmap_clear() {
    byte bitmask = bitmasks[__bitmap_color_depth];
    word vdelta = vdeltas[__bitmap_vscale];
    word hdelta = hdeltas[(__bitmap_color_depth<<2)+__bitmap_hscale];
    dword count = mul16u(hdelta,vdelta);
    char vbank = <(>__bitmap_address);
    void* vdest = (void*)   <__bitmap_address;
    memset_vram(vbank, vdest, 0, count);
}

void bitmap_plot(word x, word y, byte c) {
    // Needs unsigned int arrays arranged as two underlying char arrays to allow char* plotter_x = plot_x[x]; - and eventually - char* plotter = plot_x[x] + plot_y[y];
    dword plot_x = __bitmap_plot_x[x];
    dword plot_y = __bitmap_plot_y[y];
    dword plotter = plot_x+plot_y;
    byte bitshift = __bitmap_plot_bitshift[x];
    c = bitshift?c<<(bitshift):c;
    vera_vram_address0(plotter,VERA_INC_0);
    *VERA_DATA0 = (*VERA_DATA0 & ~__bitmap_plot_bitmask[x]) | c;
}


// Draw a line on the bitmap
void bitmap_line(word x0, word x1, word y0, word y1, byte c) {
    word xd;
    word yd;
    if(x0<x1) {
        xd = x1-x0;
        if(y0<y1) {
            yd = y1-y0;
            if(yd<xd) {
                bitmap_line_xdyi(x0, y0, x1, xd, yd, c);
            } else {
                bitmap_line_ydxi(y0, x0, y1, yd, xd, c);
            }
        } else {
            yd = y0-y1;
            if(yd<xd) {
                bitmap_line_xdyd(x0, y0, x1, xd, yd, c);
            } else {
                bitmap_line_ydxd(y1, x1, y0, yd, xd, c);
            }
        }
    } else {
        xd = x0-x1;
        if(y0<y1) {
            yd = y1-y0;
            if(yd<xd) {
                bitmap_line_xdyd(x1, y1, x0, xd, yd, c);
            } else {
                bitmap_line_ydxd(y0, x0, y1, yd, xd, c);
            }
        } else {
            yd = y0-y1;
            if(yd<xd) {
                bitmap_line_xdyi(x1, y1, x0, xd, yd, c);
            } else {
                bitmap_line_ydxi(y1, x1, y0, yd, xd, c);
            }
        }
    }
}

void bitmap_line_xdyi(word x, word y, word x1, word xd, word yd,byte c) {
  word e = yd>>1;
  do  {
      bitmap_plot(x,y,c);
      x++;
      e = e+yd;
      if(xd<e) {
          y++;
          e = e - xd;
      }
  } while (x!=(x1+1));
}

void bitmap_line_xdyd(word x, word y, word x1, word xd, word yd, byte c) {
  word e = yd>>1;
  do  {
      bitmap_plot(x,y,c);
      x++;
      e = e+yd;
      if(xd<e) {
          y--;
          e = e - xd;
      }
  } while (x!=(x1+1));
}

void bitmap_line_ydxi(word y, word x, word y1, word yd, word xd, byte c) {
  word e = xd>>1;
  do  {
      bitmap_plot(x,y,c);
      y++;
      e = e+xd;
      if(yd<e) {
          x++;
          e = e - yd;
      }
  } while (y!=(y1+1));
}

void bitmap_line_ydxd(word y, word x, word y1, word yd, word xd, byte c) {
  word e = xd>>1;
  do  {
      bitmap_plot(x,y,c);
      y = y++;
      e = e+xd;
      if(yd<e) {
          x--;
          e = e - yd;
      }
  } while (y!=(y1+1));
}


