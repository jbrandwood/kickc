// A bucket-sorting sprite multiplexer
// A multiplexer frame contains a fixed number of multiplexer buckets.
// Each multiplexer bucket represents a single raster line (typically an IRQ) where sprites are positioned.
// Each multiplexer bucket has the capability of moving 0-8 sprites.
// The bucket sorting multiplexer is used for cyclic sprite Y-movements. 
// (eg. 32 sprites in a single large 256 byte sine results in a 8 frame cycle after which the sprites can swap places and repeat the same 8 frames again to give one continous movement).
// ## Pre-calculation
// It works by pre-calculating frames and buckets into arrays of struct BucketSprite - and then using these buckets when rendering the actual multiplexer. 
// Only the Y-positions (in PLEX_YPOS) are used for pre-calculation.
// Set-up is done by
// 1. Defining PLEX_COUNT as the number of sprites in the multiplexer
// 2. Defining BUCKET_COUNT as the number of buckets per frame
// 3. Setting BUCKET_YPOS to the Y-positions of each bucket raster line
// Pre-calculation is done by
// 1. Call plexBucketInit()
// 2. For each frame:
//    a. Set up Y-positions in PLEX_YPOS
//    b. Call plexBucketSort(struct BucketSprite* frame) where frame is a BUCKET_COUNT*BUCKET_SIZE array that will receive sorted sprite-data for rendering the frame.
// Rendering is done by the following for each frame:
// 1. Set up X-positions (in PLEX_XPOS and PLEX_XPOS_MSB) and pointers (in PLEX_PTR). If they are unchanged then you do not need to change them.
// 2. Call plexBucketFrameInit()
// 3. For each bucket. 
//    a. Wait for the raster line in BUCKET_YPOS
//    b. Call plexBucketShow(bucket) where bucket is the frame array prepared in  the pre-calculation.
//    c. Move to the next bucket in the frame by doing 
//       bucket += BUCKET_SIZE;
// 4. After rendering all buckets of the frame, update the plex_id's of all the sprites in all the buckets. 
//    This is done to prepare for the next cycle where all sprites swap places to give a continous movement.
//    Typically you want to do 
//    sprite->plex_id=(sprite->plex_id-1)&(FRAME_COUNT-1)

#include "multiplex-bucket.h"
#include <c64.h>

#ifdef DEBUG_PLEX
#include <stdio.h>
#endif

#ifndef PLEX_SPRITE_PTRS
#define PLEX_SPRITE_PTRS DEFAULT_SCREEN+OFFSET_SPRITE_PTRS
#endif

// The screen sprite pointers to update
char * const SCREEN_SPRITE_PTRS = PLEX_SPRITE_PTRS;

// The Y-position (IRQ raster line) starting each bucket
char BUCKET_YPOS[BUCKET_COUNT] = { 0x10, 0x48, 0x58, 0x72, 0x8e, 0xaa, 0xc0, 0xd0, 0xde };

// The y-positions of the multiplexer sprites. (These are converted to multiplexer buckets)
char PLEX_YPOS[PLEX_COUNT];

// The low byte of the x-positions of the multiplexer sprites 
char PLEX_XPOS[PLEX_COUNT];

// The MSB of the x-positions of the multiplexer sprites (0/1)
char PLEX_XPOS_MSB[PLEX_COUNT];

// The sprite pointers for the multiplexed sprites
char PLEX_PTR[PLEX_COUNT];

// The sprite color for the multiplexed sprites
//char PLEX_COL[PLEX_COUNT];

// Indexes of the plex-sprites sorted by sprite y-position. Each call to plexSort() will fix the sorting if changes to the Y-positions have ruined it.
char PLEX_SORTED_IDX[PLEX_COUNT];

// Initialize data structures for the multiplexer
void plexPrepareInit() {
    // Initial sorting is trivial
    for(char i=0; i<PLEX_COUNT;i++) 
        PLEX_SORTED_IDX[i] = i;
}

// Performs run-time bucket sort of the sprites in the PLEX_ arrays into struct BucketSprite[]
// Starts by performing a true sorting of the sprites based on Y-position (unsing insertion sort)
void plexPrepareFrame(struct BucketSprite* frame) {
    // Sort the sprite indices in PLEX_SORTED_IDX based on the Y-position (using insertion sort)
    // Assumes that the positions are nearly sorted already (as each sprite just moves a bit)
    // 1. Moves a marker (m) from the start to end of the array. Every time the marker moves forward all elements before the marker are sorted correctly.
    // 2a. If the next element after the marker is larger that the current element
    //     the marker can be moved forwards (as the sorting is correct).
    // 2b. If the next element after the marker is smaller than the current element:
    //     elements before the marker are shifted right one at a time until encountering one smaller than the current one.
    //      It is then inserted at the spot. Now the marker can move forward.
    for(char m=0;m<PLEX_COUNT-1;m++) {
        char nxt_idx = PLEX_SORTED_IDX[m+1];
        char nxt_y = PLEX_YPOS[nxt_idx];
        if(nxt_y<PLEX_YPOS[PLEX_SORTED_IDX[m]]) {
            // Shift values until we encounter a value smaller than nxt_y
            char s = m;
            do {
                PLEX_SORTED_IDX[s+1] = PLEX_SORTED_IDX[s];
                s--;
            } while((s!=0xff) && (nxt_y<PLEX_YPOS[PLEX_SORTED_IDX[s]]));
            // store the mark at the found position
            s++;
            PLEX_SORTED_IDX[s] = nxt_idx;
        }
    }
    // Y-position where each real sprite is free (used for selecting the best bucket)
    char real_sprite_free_ypos[8];
    // Initialize real sprite free to the first bucket Y-position
    for(char i=0;i<8;i++) real_sprite_free_ypos[i] = BUCKET_YPOS[0];
    // The current real sprite idx
    char real_sprite_id = 0;
    // The current bucket idx
    char bucket_id = 0;
    // The current bucket start y-position
    char bucket_ypos = BUCKET_YPOS[bucket_id];
    // The current bucket & sprite
    struct BucketSprite *bucket = frame, *sprite = frame;
    for(char i=0;i<PLEX_COUNT; i++) {
        char plex_id = PLEX_SORTED_IDX[i];
        unsigned char ypos = PLEX_YPOS[plex_id];
        if(real_sprite_free_ypos[real_sprite_id] > bucket_ypos) {
            // The real sprite is not free in the current bucket - move to the next bucket!
            #ifdef DEBUG_PLEX
                if(bucket_id>=BUCKET_COUNT-1) printf("plex#%hhx ypos:%hhx not free in last bucket#%hhx ypos:%hhx. real sprite#%hhx free at ypos %hhx.\n", plex_id, ypos, bucket_id, bucket_ypos, real_sprite_id, real_sprite_free_ypos[real_sprite_id]);
            #endif
            // Move to the next bucket
            bucket_id++;
            bucket_ypos = BUCKET_YPOS[bucket_id];
            bucket += BUCKET_SIZE;
            // Zero-fill the next sprite in the bucket (if not full)
            if(sprite!=bucket) sprite->ypos=0;
            // Set current sprite to start of next bucket
            sprite = bucket;
        }
        // Identify problems filling buckets
        #ifdef DEBUG_PLEX
            if(ypos<=bucket_ypos) printf("plex#%hhx ypos:%hhx <= bucket#%hhx ypos:%hhx. lower bucket ypos or introduce new with lower ypos.\n", plex_id, ypos, bucket_id, bucket_ypos);
        #endif
        // Put the sprite into the bucket
        sprite->ypos = ypos;
        sprite->plex_id = plex_id;
        // Increase bucket ypos to account for time spent placing the sprite
        bucket_ypos += 1;
        // Update  next free ypos for the real sprite
        real_sprite_free_ypos[real_sprite_id] = ypos+22;
        // Move to the next real sprite
        real_sprite_id = (real_sprite_id+1)&7;        
        // Move to the next sprite in the bucket
        sprite++;
    }
    // Zero-fill the next sprite in the bucket (if not full)
    bucket += BUCKET_SIZE;
    if(sprite!=bucket) sprite->ypos=0;
}

// The next "real" sprite being used by the multiplexer
volatile char plex_real_sprite_idx = 0;

// Start a new frame (initializing data structures)
void plexFrameStart() {
    plex_real_sprite_idx = 0;
}

// Show the sprites in a specific bucket
// - bucket: The bucket to show
void plexBucketShow(struct BucketSprite* bucket) {
    // Masks used for MSB
    char MSB_SET_MASK_BY_ID[8]      = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };
    char MSB_CLEAR_MASK_BY_ID[8]    = { 0xfe, 0xfd, 0xfb, 0xf7, 0xef, 0xdf, 0xbf, 0x7f };
    // Use a char* to optimize the code!
    char* bucket_ptr = (char*)bucket;
    char real_idx = plex_real_sprite_idx*2;
    char i=0;
    while(bucket_ptr[i]) {
        SPRITES_YPOS[real_idx] = bucket_ptr[i++];
        char plex_id = bucket_ptr[i];
        SPRITES_XPOS[real_idx] = PLEX_XPOS[plex_id];
        real_idx /= 2;
        if(PLEX_XPOS_MSB[plex_id]) {
            *SPRITES_XMSB |= MSB_SET_MASK_BY_ID[real_idx];
        } else {
            *SPRITES_XMSB &= MSB_CLEAR_MASK_BY_ID[real_idx];
        }
        SCREEN_SPRITE_PTRS[real_idx] = PLEX_PTR[plex_id];
        //SPRITES_COLOR[real_idx] = PLEX_COL[plex_id];
        real_idx = (real_idx+1)&7;
        real_idx *= 2;
        i++;
        if(i==BUCKET_SIZE*sizeof(struct BucketSprite)) break;
    }
    plex_real_sprite_idx = real_idx/2;
}

// Updates the PLEX_ID's preparing for the next cycle of the multiplexer.
// Performs: sprite->plex_id=(sprite->plex_id-1)&(FRAME_COUNT-1)
void plexFrameEnd(struct BucketSprite* frame) {
    char* sprite_plex_ids = &frame->plex_id;
    for(char i=0;i<BUCKET_COUNT*BUCKET_SIZE*2;i+=2) {            
        sprite_plex_ids[i] = (sprite_plex_ids[i]-1)&(PLEX_COUNT-1);            
    }
}