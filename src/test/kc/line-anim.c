// Animated lines drawn on a single color bitmap
#include <c64.h>
#include <division.h>

byte* BITMAP = $a000;
byte* SCREEN = $8800;

// The number of points
const byte SIZE = 4;
// The delay between pixels
const byte DELAY = 8;

// The coordinates of the lines to animate
word x_start[SIZE] = { 10, 20, 30, 30 };
byte y_start[SIZE] = { 10, 10, 10, 20 };
word x_end[SIZE] =   { 20, 10, 20, 20 };
byte y_end[SIZE] =   { 20, 20, 10, 20 };

// Current x position fixed point [12.4]
word x_cur[SIZE];
// Current y position fixed point [12.4]
word y_cur[SIZE];
// X position addition per frame s[3.4]
signed byte x_add[SIZE];
// Y position addition per frame s[3.4]
signed byte y_add[SIZE];
// Frame delay (counted down to 0)
byte delay[SIZE];
// Frame number (counted down to 0)
byte frame[SIZE];

void main() {
    // Disable normal interrupt
    asm { sei }
    // Disable kernal & basic
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
    *D011 = VIC_BMM|VIC_DEN|VIC_RSEL|3;
    vicSelectGfxBank(SCREEN);
    *D018 =  toD018(SCREEN, BITMAP);
    bitmap_init(BITMAP);
    bitmap_clear();
    screen_fill(SCREEN, $10);
    for( byte i : 0..SIZE-1) {
        point_init(i);
        bitmap_plot(x_start[i], y_start[i]);
    }
    while(true) {
        while(*RASTER!=$ff) {}
        (*BORDER_COLOR)++;
    }
}

// Initialize the points to be animated
void point_init(byte point_idx) {
    signed word x_diff = ((signed word)x_end[point_idx])-((signed word)x_start[point_idx]);
    signed word y_diff = ((signed word)y_end[point_idx])-((signed word)y_start[point_idx]);

    if(abs16s(x_diff)>abs16s(y_diff)) {
        // X is driver - abs(y/x) is < 1
        if(x_diff<0){
            // x add = -1.0
            x_add[point_idx] = -$10;
        } else {
            // x add = 1.0
            x_add[point_idx] = $10;
        }
        signed word x_stepf = divr16s(0, x_diff, y_diff);
        y_add[point_idx] = (signed byte)((>x_stepf)/$10);
    } else {
        // X is driver - abs(x/y) is < 1
    }
    x_cur[point_idx] = x_start[point_idx]*$10;
    y_cur[point_idx] = ((word)y_start[point_idx])*$10;
    delay[point_idx] = DELAY;
}

// Return the absolute (unsigned) value of a word
inline word abs16s(signed word w) {
    if(w<0) {
        return (word) -w;
    } else {
        return (word) w;
    }
}

// Fill the screen with a specific char
void screen_fill(byte* screen, byte ch) {
    for( byte y: 0..24) {
        for(byte x:0..39) {
            *screen++ = ch;
        }
    }
}

// Tables for the plotter - initialized by calling bitmap_init();
const byte bitmap_plot_ylo[256];
const byte bitmap_plot_yhi[256];
const byte bitmap_plot_bit[256];

void bitmap_init(byte* bitmap) {
    byte bits = $80;
    for(byte x : 0..255) {
        bitmap_plot_bit[x] = bits;
        bits >>= 1;
        if(bits==0) {
          bits = $80;
        }
    }
    byte* yoffs = bitmap;
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
    byte* bitmap = (byte*) { bitmap_plot_yhi[0], bitmap_plot_ylo[0] };
    for( byte y: 0..39 ) {
        for( byte x: 0..199 ) {
            *bitmap++ = 0;
        }
    }
}

// Plot a single dot in the bitmap
void bitmap_plot(word x, byte y) {
    byte* plotter = (byte*) { bitmap_plot_yhi[y], bitmap_plot_ylo[y] };
    plotter += ( x & $fff8 );
    *plotter |= bitmap_plot_bit[<x];
}
