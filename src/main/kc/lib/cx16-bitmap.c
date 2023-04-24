// Plot and line drawing routines for HIRES bitmaps
// Currently it can only plot on the first 256 x-positions.

#include <cx16.h>
#include <cx16-bitmap.h>
#include <cx16-veralib.h>
#include <multiply.h>

typedef struct {
    // Tables for the plotter - initialized by calling bitmap_draw_init();
    unsigned int  plot_x[640];
    unsigned long plot_y[480];
    unsigned char  plot_bitmask[640];
    unsigned char  plot_bitshift[640];

    unsigned long address;
    unsigned char layer;
    unsigned char hscale;
    unsigned char vscale;
    unsigned char color_depth;
} bitmap_t;

bitmap_t __bitmap;


unsigned int hdeltas[16] = {
    0, 80, 40, 20,    // 1 BPP
    0, 160, 80, 40,   // 2 BPP
    0, 320, 160, 80,  // 4 BPP
    0, 640, 320, 160  // 8 BPP
    };
const unsigned int vdeltas[4] = {0, 480, 240, 160};
const unsigned char bitmasks[5] = {0x80, 0xC0, 0xF0, 0xFF};
const signed char bitshifts[5] = {7, 6, 4, 0};


unsigned char bitmap_hscale()
{
    unsigned char hscale[4] = {0,128,64,32};
    unsigned char scale = 0;
    for(char s=1;s<=3;s++) {
        if(*VERA_DC_HSCALE==hscale[s]) {
            scale = s;
            break;
        }
    }
    return scale;
}

unsigned char bitmap_vscale()
{
    unsigned char vscale[4] = {0,128,64,32};
    unsigned char scale = 0;
    for(char s=1;s<=3;s++) {
        if(*VERA_DC_VSCALE==vscale[s]) {
            scale = s;
            break;
        }
    }
    return scale;
}


// Initialize the bitmap plotter tables for a specific bitmap
void bitmap_init(unsigned char layer, unsigned char bank, unsigned int offset)
{
    __bitmap.address = MAKELONG(offset, bank);
    __bitmap.layer = layer;
    if(layer) {
        __bitmap.color_depth = (*VERA_L1_CONFIG & VERA_LAYER_COLOR_DEPTH_MASK);
    } else {
        __bitmap.color_depth = (*VERA_L0_CONFIG & VERA_LAYER_COLOR_DEPTH_MASK);
    }
    __bitmap.hscale = bitmap_hscale(); // Returns 1 when 640 and 2 when 320, 3 when 160.
    __bitmap.vscale = bitmap_vscale(); // Returns 1 when 480 and 2 when 240, 3 when 160.

    unsigned char bitmask = bitmasks[__bitmap.color_depth];
    signed char bitshift = bitshifts[__bitmap.color_depth];

    for(unsigned int x=0; x<630; x++) {
        // 1 BPP
        if(__bitmap.color_depth==0) {
            __bitmap.plot_x[x] = (x >> 3);
            __bitmap.plot_bitmask[x] = bitmask;
            __bitmap.plot_bitshift[x] = (unsigned char)bitshift;
            bitshift -= 1;
            bitmask >>= 1;
        }
        // 2 BPP
        if(__bitmap.color_depth==1) {
            __bitmap.plot_x[x] = (x >> 2);
            __bitmap.plot_bitmask[x] = bitmask;
            __bitmap.plot_bitshift[x] = (unsigned char)bitshift;
            bitshift -= 2;
            bitmask >>= 2;
        }
        // 4 BPP
        if(__bitmap.color_depth==2) {
            __bitmap.plot_x[x] = (x >> 1);
            __bitmap.plot_bitmask[x] = bitmask;
            __bitmap.plot_bitshift[x] = (unsigned char)bitshift;
            bitshift -= 4;
            bitmask >>= 4;
        }
        // 8 BPP
        if(__bitmap.color_depth==3) {
            __bitmap.plot_x[x] = x;
            __bitmap.plot_bitmask[x] = bitmask;
            __bitmap.plot_bitshift[x] = (unsigned char)bitshift;
        }
        if(bitshift<0) {
            bitshift = bitshifts[__bitmap.color_depth];
        }
        if(bitmask==0) {
            bitmask = bitmasks[__bitmap.color_depth];
        }
    }

    // This sets the right delta to skip a whole line based on the scale, depending on the color depth.
    unsigned int hdelta = hdeltas[(__bitmap.color_depth<<2)+__bitmap.hscale];
    // We start at the bitmap offset; The plot_y contains the bitmap offset embedded so we know where a line starts.
    unsigned long yoffs = __bitmap.address;
    for(unsigned int y=0; y<479; y++) {
        __bitmap.plot_y[y] = yoffs;
        yoffs = yoffs + hdelta;
    }
}

// Clear all graphics on the bitmap
void bitmap_clear() {
    unsigned char bitmask = bitmasks[__bitmap.color_depth];
    unsigned int vdelta = vdeltas[__bitmap.vscale];
    unsigned int hdelta = hdeltas[(__bitmap.color_depth<<2)+__bitmap.hscale];
    hdelta = hdelta >> 1;
    unsigned int count = (unsigned int)mul16u(hdelta,vdelta);
    vram_bank_t vbank = BYTE3(__bitmap.address);
    vram_offset_t vdest = WORD0(__bitmap.address);
    memset_vram(vbank, vdest, 0, count); // TODO: check this out if it still works properly.
}

void bitmap_plot(unsigned int x, unsigned int y, unsigned char c) {
    // Needs unsigned int arrays arranged as two underlying char arrays to allow char* plotter_x = plot_x[x]; - and eventually - char* plotter = plot_x[x] + plot_y[y];
    unsigned long plot_x = __bitmap.plot_x[x];
    unsigned long plot_y = __bitmap.plot_y[y];
    unsigned long plotter = plot_x+plot_y;
    unsigned char bitshift = __bitmap.plot_bitshift[x];
    c = bitshift?c<<(bitshift):c;
    vera_vram_data0_address(plotter,VERA_INC_0);
    *VERA_DATA0 = (*VERA_DATA0 & ~__bitmap.plot_bitmask[x]) | c;
}


// Draw a line on the bitmap
void bitmap_line(unsigned int x0, unsigned int x1, unsigned int y0, unsigned int y1, unsigned char c) {
    unsigned int xd;
    unsigned int yd;
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

void bitmap_line_xdyi(unsigned int x, unsigned int y, unsigned int x1, unsigned int xd, unsigned int yd,unsigned char c) {
  unsigned int e = yd>>1;
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

void bitmap_line_xdyd(unsigned int x, unsigned int y, unsigned int x1, unsigned int xd, unsigned int yd, unsigned char c) {
  unsigned int e = yd>>1;
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

void bitmap_line_ydxi(unsigned int y, unsigned int x, unsigned int y1, unsigned int yd, unsigned int xd, unsigned char c) {
  unsigned int e = xd>>1;
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

void bitmap_line_ydxd(unsigned int y, unsigned int x, unsigned int y1, unsigned int yd, unsigned int xd, unsigned char c) {
  unsigned int e = xd>>1;
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


