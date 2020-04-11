// Fill screen using a spiral based on distance-to-center / angle-to-center

#include <stdlib.h>
#include <sqr.h>
#include <atan2.h>


// Screen containing distance to center
byte* SCREEN_DIST = malloc(1000);
// Screen containing angle to center
byte* SCREEN_ANGLE = malloc(1000);
// Screen containing angle to center
byte* const SCREEN_FILL = 0x0400;

// Char to fill with
const byte FILL_CHAR = '@';

void main() {
    init_dist_screen(SCREEN_DIST);
    init_angle_screen(SCREEN_ANGLE);
    while(true) {
        // Find the minimum dist/angle that is not already filled
        byte* dist = SCREEN_DIST;
        byte* angle = SCREEN_ANGLE;
        byte* fill = SCREEN_FILL;
        word min_dist_angle = 0xffff;
        byte* min_fill = SCREEN_FILL;
        do {
            if(*fill!=FILL_CHAR) {
                word dist_angle = { *dist, *angle };
                if(dist_angle<min_dist_angle) {
                    min_fill = fill;
                    min_dist_angle = dist_angle;
                }
            }
            dist++;
            angle++;
            fill++;
        } while (fill<SCREEN_FILL+1000);
        // Break if not found (means we are done)
        if(min_dist_angle==0xffff)
            break;
        // Fill the found location
        *min_fill = FILL_CHAR;
    }
}



// Populates 1000 bytes (a screen) with values representing the angle to the center.
// Utilizes symmetry around the  center
void init_angle_screen(byte* screen) {
    byte* screen_topline = screen+40*12;
    byte *screen_bottomline = screen+40*12;
    for(byte y: 0..12) {
        for( byte x=0,xb=39; x<=19; x++, xb--) {
            signed word xw = (signed word)(word){ 39-x*2, 0 };
            signed word yw = (signed word)(word){ y*2, 0 };
            word angle_w = atan2_16(xw, yw);
            byte ang_w = >(angle_w+0x0080);
            screen_bottomline[xb] = ang_w;
            screen_topline[xb] = -ang_w;
            screen_topline[x] = 0x80+ang_w;
            screen_bottomline[x] = 0x80-ang_w;
        }
        screen_topline -= 40;
        screen_bottomline += 40;
    }
}

// Populates 1000 bytes (a screen) with values representing the distance to the center.
// The actual value stored is distance*2 to increase precision
void init_dist_screen(byte* screen) {
    NUM_SQUARES = 0x30;
    init_squares();
    byte* screen_topline = screen;
    byte *screen_bottomline = screen+40*24;
    for(byte y: 0..12) {
        byte y2 = y*2;
        byte yd = (y2>=24)?(y2-24):(24-y2);
        word yds = sqr(yd);
        for( byte x=0,xb=39; x<=19; x++, xb--) {
            byte x2 = x*2;
            byte xd = (x2>=39)?(x2-39):(39-x2);
            word xds = sqr(xd);
            word ds = xds+yds;
            byte d = sqrt(ds);
            screen_topline[x] = d;
            screen_bottomline[x] = d;
            screen_topline[xb] = d;
            screen_bottomline[xb] = d;
        }
        screen_topline += 40;
        screen_bottomline -= 40;
    }
}