// Plots a circle on a bitmap using Bresenham's Circle algorithm
// Coded by Richard-William Loerakker
// Original Source https://bcaorganizer.blogspot.com/p/c-program-for_21.html?fbclid=IwAR0iL8pYcCqhCPa6LmtQ9qej-YonYVepY2cBegYRIWO0l8RPeOnTVniMAac


byte* const SCREEN = (byte*)$400;
byte* const BITMAP = (byte*)$2000;
byte* const COLORS = (byte*)$d800;

byte bitmask[] = { 128, 64, 32, 16, 8, 4, 2, 1 };

char*  const D011 = (char*)0xd011;
char*  const VICII_MEMORY = (char*)0xd018;
char*  const BORDER_COLOR = (char*)0xd020;
const char VICII_BMM =  %00100000;
const char VICII_DEN =  %00010000;
const char VICII_RSEL = %00001000;
const char BLUE = 0x6;

void main() {
    fill(BITMAP,40*25*8,0);
    fill(SCREEN,40*25,$16);

    *BORDER_COLOR = BLUE;
    *D011 = VICII_BMM|VICII_DEN|VICII_RSEL|3;
    *VICII_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)BITMAP&$3fff)/$400));

    circle(100,100,50);

    do {} while (true);
}

void circle(int xc, int yc, int r) {
    int x = 0;
    int y = r;
    int p = 3-(r << 1);

    for(int x = 0; x <= y; x ++) {
        if(p < 0) {
            p = p + (x << 2) + 6;
        } else {
            y=y-1;
            p = p + ((x-y) << 2) + 10;
        }

        plot(xc+x,yc-y);
        plot(xc-x,yc-y);
        plot(xc+x,yc+y);
        plot(xc-x,yc+y);
        plot(xc+y,yc-x);
        plot(xc-y,yc-x);
        plot(xc+y,yc+x);
        plot(xc-y,yc+x);
    }
}

void plot(int x, int y) {
    byte* location = BITMAP;
    location += x & $fff8;
    location += (char)y & 7;
    location += ((y >> 3) * 320);
    (*location) = (*location) | bitmask[x & 7];
}

// Fill some memory with a value
void fill(byte* start, int size, byte val) {
    byte* end = start + size;
    for(byte* addr = start; addr!=end; addr++) {
        *addr = val;
    }
}

