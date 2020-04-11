// Plot and line drawing routines for HIRES bitmaps
// Currently it can only plot on the first 256 x-positions.

// Tables for the plotter - initialized by calling bitmap_draw_init();
const byte bitmap_plot_xlo[256];
const byte bitmap_plot_xhi[256];
const byte bitmap_plot_ylo[256];
const byte bitmap_plot_yhi[256];
const byte bitmap_plot_bit[256];

// Initialize the bitmap plotter tables for a specific bitmap
void bitmap_init(byte* bitmap) {
    byte bits = $80;
    for(byte x : 0..255) {
        bitmap_plot_xlo[x] = x&$f8;
        bitmap_plot_xhi[x] = >bitmap;
        bitmap_plot_bit[x] = bits;
        bits = bits>>1;
        if(bits==0) {
          bits = $80;
        }
    }
    byte* yoffs = $0;
    for(byte y : 0..255) {
        bitmap_plot_ylo[y] = y&$7 | <yoffs;
        bitmap_plot_yhi[y] = >yoffs;
        if((y&$7)==7) {
            yoffs = yoffs + 40*8;
        }
    }
}

// Clear all graphics on the bitmap
void bitmap_clear() {
    byte* bitmap = (byte*) { bitmap_plot_xhi[0], bitmap_plot_xlo[0] };
    for( byte y: 0..39 ) {
        for( byte x: 0..199 ) {
            *bitmap++ = 0;
        }
    }
}

void bitmap_plot(byte x, byte y) {
    // Needs word arrays arranged as two underlying byte arrays to allow byte* plotter_x = plot_x[x]; - and eventually - byte* plotter = plot_x[x] + plot_y[y];
    word plotter_x = { bitmap_plot_xhi[x], bitmap_plot_xlo[x] };
    word plotter_y = { bitmap_plot_yhi[y], bitmap_plot_ylo[y] };
    byte* plotter = plotter_x+plotter_y;
    *plotter = *plotter | bitmap_plot_bit[x];
}


// Draw a line on the bitmap
void bitmap_line(byte x0, byte x1, byte y0, byte y1) {
    byte xd;
    byte yd;
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

void bitmap_line_xdyi(byte x, byte y, byte x1, byte xd, byte yd) {
  byte e = yd>>1;
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

void bitmap_line_xdyd(byte x, byte y, byte x1, byte xd, byte yd) {
  byte e = yd>>1;
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

void bitmap_line_ydxi(byte y, byte x, byte y1, byte yd, byte xd) {
  byte e = xd>>1;
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

void bitmap_line_ydxd(byte y, byte x, byte y1, byte yd, byte xd) {
  byte e = xd>>1;
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


