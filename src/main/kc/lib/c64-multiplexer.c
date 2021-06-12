// A flexible sprite multiplexer routine for 32 sprites.
// Usage:
// - Once:
// - plexInit(screen): Initialize the data structures and set the screen address
// Each frame:
// - Set x-pos, y-pos and pointer in PLEX_XPOS[id], PLEX_YPOS[id], PLEX_PTR[id]
// - plexSort() Sorts the sprites according to y-positions and prepares for showing them. This uses an insertion sort that is quite fast when the relative order of the sprites does not change very much.
// - plexShowSprite() Shows the next sprite by copying values from PLEX_XXX[] to an actual sprite. Actual sprites are used round-robin. This should be called once for each of the 24 virtual sprites.
// - plexFreeNextYpos() Returns the Y-position where the next sprite is available to be shown (ie. the next pos where the next sprite is no longer in use showing something else).
// - plexShowNextYpos() Returns the Y-position of the next sprite to show.
//
// In practice a good method is to wait until the raster is beyond plexFreeNextYpos() and then call plexShowSprite(). Repeat until all 32 sprites have been shown.
// TODO: Let the caller specify the number of sprites to use (or add PLEX_ENABLE[PLEX_COUNT])

#include <c64-multiplexer.h>
#include <c64.h>

// The number of sprites in the multiplexer
const char PLEX_COUNT = 32;

// The x-positions of the multiplexer sprites (0x000-0x1ff)
unsigned int PLEX_XPOS[PLEX_COUNT];

// The y-positions of the multiplexer sprites.
char PLEX_YPOS[PLEX_COUNT];

// The sprite pointers for the multiplexed sprites
char PLEX_PTR[PLEX_COUNT];

// The address of the sprite pointers on the current screen (screen+0x3f8).
char* volatile PLEX_SCREEN_PTR = (char*)0x400+0x3f8;

// Indexes of the plex-sprites sorted by sprite y-position. Each call to plexSort() will fix the sorting if changes to the Y-positions have ruined it.
char PLEX_SORTED_IDX[PLEX_COUNT];

// Variables controlling the showing of sprites

// The index in the PLEX tables of the next sprite to show
volatile char plex_show_idx=0;
// The index the next sprite to use for showing (sprites are used round-robin)
volatile char plex_sprite_idx=0;
// The MSB bit of the next sprite to use for showing
volatile char plex_sprite_msb=1;

// Initialize the multiplexer data structures
void plexInit(char* screen) {
    plexSetScreen(screen);
    for(char i: 0..PLEX_COUNT-1) {
        PLEX_SORTED_IDX[i] = i;
    }
}

// Set the address of the current screen used for setting sprite pointers (at screen+0x3f8)
inline void plexSetScreen(char* screen) {
    PLEX_SCREEN_PTR = screen+0x3f8;
}

// Ensure that the indices in PLEX_SORTED_IDX is sorted based on the y-positions in PLEX_YPOS
// Assumes that the positions are nearly sorted already (as each sprite just moves a bit)
// Uses an insertion sort:
// 1. Moves a marker (m) from the start to end of the array. Every time the marker moves forward all elements before the marker are sorted correctly.
// 2a. If the next element after the marker is larger that the current element
//     the marker can be moved forwards (as the sorting is correct).
// 2b. If the next element after the marker is smaller than the current element:
//     elements before the marker are shifted right one at a time until encountering one smaller than the current one.
//      It is then inserted at the spot. Now the marker can move forward.
void plexSort() {
    for(char m: 0..PLEX_COUNT-2) {
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
    // Prepare for showing the sprites
    plex_show_idx = 0;
    plex_sprite_idx = 0;
    plex_sprite_msb = 1;
    plexFreePrepare();
}

// Show the next sprite.
// plexSort() prepares showing the sprites
void plexShowSprite() {
    char plex_sprite_idx2 = plex_sprite_idx*2;
    char ypos = PLEX_YPOS[PLEX_SORTED_IDX[plex_show_idx]];
    SPRITES_YPOS[plex_sprite_idx2] = ypos;
    plexFreeAdd(ypos);
    PLEX_SCREEN_PTR[plex_sprite_idx] = PLEX_PTR[PLEX_SORTED_IDX[plex_show_idx]];
    char xpos_idx = PLEX_SORTED_IDX[plex_show_idx];
    SPRITES_XPOS[plex_sprite_idx2] = (char)PLEX_XPOS[xpos_idx];
    if(BYTE1(PLEX_XPOS[xpos_idx])!=0) {
        *SPRITES_XMSB |= plex_sprite_msb;
    } else {
        *SPRITES_XMSB &= (0xff^plex_sprite_msb);
    }
    plex_sprite_idx = (plex_sprite_idx+1)&7;
    plex_show_idx++;
    plex_sprite_msb <<=1;
    if(plex_sprite_msb==0) {
        plex_sprite_msb = 1;
    }
}

// Get the y-position of the next sprite to show
inline char plexShowNextYpos() {
    return PLEX_YPOS[PLEX_SORTED_IDX[plex_show_idx]];
}

// Contains the Y-position where each sprite is free again. PLEX_FREE_YPOS[s] holds the Y-position where sprite s is free to use again.
char PLEX_FREE_YPOS[8];

// The index of the sprite that is free next. Since sprites are used round-robin this moves forward each time a sprite is shown.
volatile char plex_free_next = 0;

// Prepare for a new frame. Initialize free to zero for all sprites.
inline void plexFreePrepare() {
    for( char s: 0..7) {
        PLEX_FREE_YPOS[s] = 0;
    }
    plex_free_next = 0;
}

// Get the Y-position where the next sprite to be shown is free to use.
inline char plexFreeNextYpos() {
    return PLEX_FREE_YPOS[plex_free_next];
}

// Update the data structure to reflect that a sprite has been shown. This sprite will be free again after 21 lines.
inline void plexFreeAdd(char ypos) {
    PLEX_FREE_YPOS[plex_free_next] =  ypos+22;
    plex_free_next = (plex_free_next+1)&7;
}