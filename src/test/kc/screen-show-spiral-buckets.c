// Fill screen using a spiral based on distance-to-center / angle-to-center
// Utilizes a bucket sort for identifying the minimum angle/distance

#include <c64.h>
#include <stdlib.h>
#include <sqr.h>
#include <atan2.h>

// Screen containing distance to center
byte* SCREEN_DIST = malloc(1000);
// Screen containing angle to center
byte* SCREEN_ANGLE= malloc(1000);
// Screen containing angle to center
byte* const SCREEN_FILL = (char*)0x0400;

// Char to fill with
const byte FILL_CHAR = '*';

// The number of buckets in our bucket sort
const byte NUM_BUCKETS = 0x30;

// Array containing the bucket size for each of the distance buckets
byte* BUCKET_SIZES = malloc(NUM_BUCKETS*sizeof(byte));

// Buckets containing screen indices for each distance from the center.
// BUCKETS[dist] is an array of words containing screen indices.
// The size of the array BUCKETS[dist] is BUCKET_SIZES[dist]
word** BUCKETS = malloc(NUM_BUCKETS*sizeof(word*));

// Current index into each bucket. Used while populating the buckets. (After population the end the values will be equal to the bucket sizes)
byte* BUCKET_IDX = malloc(NUM_BUCKETS*sizeof(byte));



void main() {
    asm { sei }
    init_dist_screen(SCREEN_DIST);
    init_angle_screen(SCREEN_ANGLE);
    init_buckets(SCREEN_DIST);

    // Animate a spiral walking through the buckets one at a time
    byte bucket_idx = 0;
    while(true) {
        do { } while (*RASTER!=0xff);
        (*BORDER_COLOR)++;
        word* bucket = BUCKETS[bucket_idx];
        byte bucket_size = BUCKET_SIZES[bucket_idx];
        if(bucket_size>0) {
            // Find the minimum unfilled angle in the current bucket
            byte min_angle = 0xff;
            word min_offset = 0xffff;
            for( byte i=0;i<bucket_size;i++) {
                word offset = bucket[i];
                byte* fill = SCREEN_FILL+offset;
                if(*fill!=FILL_CHAR) {
                    byte* angle = SCREEN_ANGLE+offset;
                    if(*angle<=min_angle) {
                        min_angle = *angle;
                        min_offset = offset;
                    }
                }
            }
            // Fill it if found
            if(min_offset!=0xffff) {
                // Found something to fill!
                byte* fill = SCREEN_FILL+min_offset;
                *fill = FILL_CHAR;
                (*BORDER_COLOR)--;
                continue;
            }
        }
        // Nothing found - Move to next bucket!
        bucket_idx++;
        if(bucket_idx==NUM_BUCKETS) {
            // All buckets complete - exit loop!
            (*BORDER_COLOR)--;
            break;
        }
        (*BORDER_COLOR)--;
    }
    while(true)
        (*(COLS+999))++;
}

// Initialize buckets containing indices of chars on the screen with specific distances to the center.
void init_buckets(byte* screen) {
    // Init bucket sizes to 0
    for(byte i:0..NUM_BUCKETS-1) BUCKET_SIZES[i]=0;
    // first find bucket sizes - by counting number of chars with each distance value
    byte* dist = screen;
    for( word i:0..999) {
        BUCKET_SIZES[*dist]++;
        dist++;
    }
    // Allocate the buckets
    for( word i:0..NUM_BUCKETS-1) {
        BUCKETS[i] = malloc(BUCKET_SIZES[i]*sizeof(byte*));
    }
    // Iterate all distances and fill the buckets with indices into the screens
    for(byte i:0..NUM_BUCKETS-1) BUCKET_IDX[i]=0;
    dist = screen;
    for(word i:0..999) {
        byte distance = *dist;
        word* bucket = BUCKETS[(word)distance];
        bucket[BUCKET_IDX[distance]] = dist-screen;
        BUCKET_IDX[distance]++;
        *dist++;
    }
}

// Populates 1000 bytes (a screen) with values representing the angle to the center.
// Utilizes symmetry around the center
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
// Utilizes symmetry around the center
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