// Plot and line drawing routines for HIRES bitmaps
// Currently it can only plot on the first 256 x-positions.

#include <bitmap-draw.h>

// Tables for the plotter - initialized by calling bitmap_draw_init();
const char bitmap_plot_xlo[256];
const char bitmap_plot_xhi[256];
const char bitmap_plot_ylo[256];
const char bitmap_plot_yhi[256];
const char bitmap_plot_bit[256];

// Initialize the bitmap plotter tables for a specific bitmap
void bitmap_init(char* bitmap) {
    char bits = $80;
    for(char x : 0..255) {
        bitmap_plot_xlo[x] = x&$f8;
        bitmap_plot_xhi[x] = >bitmap;
        bitmap_plot_bit[x] = bits;
        bits = bits>>1;
        if(bits==0) {
          bits = $80;
        }
    }
    char* yoffs = $0;
    for(char y : 0..255) {
        bitmap_plot_ylo[y] = y&$7 | <yoffs;
        bitmap_plot_yhi[y] = >yoffs;
        if((y&$7)==7) {
            yoffs = yoffs + 40*8;
        }
    }
}

// Clear all graphics on the bitmap
void bitmap_clear() {
    char* bitmap = (char*) { bitmap_plot_xhi[0], bitmap_plot_xlo[0] };
    for( char y: 0..39 ) {
        for( char x: 0..199 ) {
            *bitmap++ = 0;
        }
    }
}

void bitmap_plot(char x, char y) {
    // Needs unsigned int arrays arranged as two underlying char arrays to allow char* plotter_x = plot_x[x]; - and eventually - char* plotter = plot_x[x] + plot_y[y];
    unsigned int plotter_x = { bitmap_plot_xhi[x], bitmap_plot_xlo[x] };
    unsigned int plotter_y = { bitmap_plot_yhi[y], bitmap_plot_ylo[y] };
    char* plotter = plotter_x+plotter_y;
    *plotter = *plotter | bitmap_plot_bit[x];
}


// Draw a line on the bitmap
void bitmap_line(char x0, char x1, char y0, char y1) {
    char xd;
    char yd;
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

void bitmap_line_xdyi(char x, char y, char x1, char xd, char yd) {
  char e = yd>>1;
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

void bitmap_line_xdyd(char x, char y, char x1, char xd, char yd) {
  char e = yd>>1;
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

void bitmap_line_ydxi(char y, char x, char y1, char yd, char xd) {
  char e = xd>>1;
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

void bitmap_line_ydxd(char y, char x, char y1, char yd, char xd) {
  char e = xd>>1;
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


