byte* D011 = (byte*)$d011;
  byte RST8 = %10000000;
  byte ECM =  %01000000;
  byte BMM =  %00100000;
  byte DEN =  %00010000;
  byte RSEL =  %00001000;
byte* RASTER = (byte*)$d012;
byte* D016 = (byte*)$d016;
  byte MCM =  %00010000;
  byte CSEL = %00001000;
byte* D018 = (byte*)$d018;
byte* BG_COLOR = (byte*)$d020;
byte* FGCOL = (byte*)$d021;

byte* COLS = (byte*)$d800;


byte* SCREEN = (byte*)$400;
byte* const BITMAP = (byte*)$2000;

void main() {
    *BG_COLOR = 0;
    *FGCOL = 0;
    *D011 = BMM|DEN|RSEL|3;
    *D018 = (byte)(((word)SCREEN/$40)|((word)BITMAP/$400));
    init_screen();
    init_plot_tables();
    do {
        do {} while (*RASTER!=$ff);
        (*BG_COLOR)++;
        plots();
        (*BG_COLOR)--;
    } while (true);
}

byte plots_x[] = { 60, 80, 110, 80, 60, 40, 10, 40 };
byte plots_y[] = { 10, 40, 60, 80, 110, 80, 60, 40 };
byte plots_cnt = 8;

void plots() {
    for(byte i=0; i<plots_cnt;i++) {
        plot(plots_x[i], plots_y[i]);
    }
}

const byte plot_xlo[256];
const byte plot_xhi[256];
const byte plot_ylo[256];
const byte plot_yhi[256];
const byte plot_bit[256];

void plot(byte x, byte y) {
    byte* plotter_x = (byte*)0;
    word plotter_y = 0;
    BYTE1(plotter_x) = plot_xhi[x];  // Needs word arrays arranged as two underlying byte arrays to allow byte* plotter_x = plot_x[x]; - and eventually - byte* plotter = plot_x[x] + plot_y[y];
    BYTE0(plotter_x) = plot_xlo[x];
    BYTE1(plotter_y) = plot_yhi[y];
    BYTE0(plotter_y) = plot_ylo[y];
    byte* plotter = plotter_x+plotter_y;
    *plotter = *plotter | plot_bit[x];
}

void init_plot_tables() {
    byte bits = $80;
    for(byte x : 0..255) {
        plot_xlo[x] = x&$f8;
        plot_xhi[x] = BYTE1(BITMAP);
        plot_bit[x] = bits;
        bits = bits/2;
        if(bits==0) {
          bits = $80;
        }
    }
    byte* yoffs = (byte*)$0;
    for(byte y : 0..255) {
        plot_ylo[y] = y&$7 | BYTE0(yoffs);
        plot_yhi[y] = BYTE1(yoffs);
        if((y&$7)==7) {
            yoffs = yoffs + 40*8; // Needs better constant type inference for yoffs = yoffs + 40*8;
        }
    }
}

void init_screen() {
    for(byte* b = BITMAP; b!=BITMAP+$2000; b++) {
        *b = 0;
    }
    for(byte* c = SCREEN; c!=SCREEN+$400;c++) {
        *c = $14;
    }
}
