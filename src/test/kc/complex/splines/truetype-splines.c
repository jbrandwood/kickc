// Show a few simple splines using the splines library

#include "splines.c"
#include <bitmap2.h>
#include <time.h>
#include <print.h>
#include <fastmultiply.h>
#include <c64.h>

char* const PRINT_SCREEN = 0x0400;
char* const BITMAP_SCREEN = 0x5c00;
char* const BITMAP_GRAPHICS = 0x6000;

// A segment of a spline
struct Segment {
    enum SegmentType { MOVE_TO, SPLINE_TO, LINE_TO} type;
    struct SplineVector16 to;
    struct SplineVector16 via;
};

// True type letter c
struct Segment letter_c[22] = {
     { MOVE_TO, {108,146}, {0,0} },
     { SPLINE_TO, {89,182}, {103,169} },
     { SPLINE_TO, {59,195}, {75,195} },
     { SPLINE_TO, {23,178}, {38,195} },
     { SPLINE_TO, {9,132}, {9,161} },
     { SPLINE_TO, {25,87}, {9,104} },
     { SPLINE_TO, {65,69}, {42,69} },
     { SPLINE_TO, {93,79}, {82,69} },
     { SPLINE_TO, {105,98}, {105,88} },
     { SPLINE_TO, {102,106}, {105,103} },
     { SPLINE_TO, {93,109}, {98,109} },
     { SPLINE_TO, {81,104}, {85,109} },
     { SPLINE_TO, {78,93}, {79,101} },
     { SPLINE_TO, {73,82}, {78,86} },
     { SPLINE_TO, {61,78}, {69,78} },
     { SPLINE_TO, {40,88}, {48,78} },
     { SPLINE_TO, {29,121}, {29,100} },
     { SPLINE_TO, {40,158}, {29,142} },
     { SPLINE_TO, {68,174}, {50,174} },
     { SPLINE_TO, {91,166}, {80,174} },
     { SPLINE_TO, {104,144}, {98,160} },
     { LINE_TO, {108,146}, {0,0} }
};

void main() {
    mulf_init();
    bitmap_init(BITMAP_GRAPHICS, BITMAP_SCREEN);
    bitmap_clear(BLACK, WHITE);
    vicSelectGfxBank(BITMAP_SCREEN);
    *D018 = toD018(BITMAP_SCREEN, BITMAP_GRAPHICS);
    *D011 = VICII_BMM|VICII_DEN|VICII_RSEL|3;

    char angle = 0;
    while(true) {
        bitmap_clear(BLACK, WHITE);
        show_letter(angle);
        for ( byte w: 0..60) {
            do {} while(*RASTER!=0xfe);
            do {} while(*RASTER!=0xff);
        }
        angle += 9;
    }

    while(true) { (*(PRINT_SCREEN+999))++; }
}

void show_letter(char angle) {
    struct SplineVector16 current = {0,0};
    for( byte i: 0..21) {
        struct SplineVector16 to = letter_c[i].to;
        to = { to.x - 50, to.y - 150};
        to = rotate(to, angle);
        to = { to.x + 100, to.y + 100};
        struct SplineVector16 via = letter_c[i].via;
        via = { via.x - 50, via.y - 150};
        via = rotate(via, angle);
        via = { via.x + 100, via.y + 100};
        struct Segment segment = { letter_c[i].type, to, via};
        if(segment.type==MOVE_TO) {
            //bitmap_plot((unsigned int)segment.to.x, (unsigned char)segment.to.y);
            current = segment.to;
        } else if(segment.type==SPLINE_TO) {
            spline_8segB(current, segment.via, segment.to);
            bitmap_plot_spline_8seg();
            //bitmap_plot((unsigned int)segment.to.x, (unsigned char)segment.to.y);
            //bitmap_plot((unsigned int)segment.via.x, (unsigned char)segment.via.y);
            current = segment.to;
        } else {
            bitmap_line((unsigned int)current.x, (unsigned int)current.y, (unsigned int)segment.to.x, (unsigned int)segment.to.y);
            current = segment.to;
        }
    }
}


// Plot the spline in the SPLINE_8SEG array
void bitmap_plot_spline_8seg() {
    struct SplineVector16 current = SPLINE_8SEG[0];
    for(char n:1..8) {
        bitmap_line((unsigned int)current.x, (unsigned int)current.y, (unsigned int)SPLINE_8SEG[n].x, (unsigned int)SPLINE_8SEG[n].y);
        //bitmap_plot((unsigned int)current.x, (unsigned char)current.y);
        current = SPLINE_8SEG[n];
    }
}

// Sine and Cosine tables
// Angles: $00=0, $80=PI,$100=2*PI
// Sine/Cosine: signed fixed [-$7f,$7f]
signed char __align(0x40) SIN[0x140] = kickasm {{
    .for(var i=0;i<$140;i++)
        .byte >round($7fff*sin(i*2*PI/256))
}};

signed char* COS = SIN+$40; // sin(x) = cos(x+PI/2)

// 2D-rotate a vector by an angle
struct SplineVector16 rotate(struct SplineVector16 vector, char angle) {
        signed int cos_a = (signed int) COS[angle]; // signed fixed[0.7]
        signed int xr = (signed int )mulf16s(cos_a, vector.x)*2; // signed fixed[8.8]
        signed int yr = (signed int )mulf16s(cos_a, vector.y)*2; // signed fixed[8.8]
        signed int sin_a = (signed int) SIN[angle]; // signed fixed[0.7]
	    xr -= (signed int)mulf16s(sin_a, vector.y)*2; // signed fixed[8.8]
		yr += (signed int)mulf16s(sin_a, vector.x)*2; // signed fixed[8.8]
        struct SplineVector16 rotated = { (signed int)(signed char)>xr, (signed int)(signed char)>yr };
        return rotated;
}
