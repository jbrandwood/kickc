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

#include <c64.h>

// The number of sprites in the multiplexer
extern const char PLEX_COUNT;

// The x-positions of the multiplexer sprites (0x000-0x1ff)
extern unsigned int PLEX_XPOS[PLEX_COUNT];

// The y-positions of the multiplexer sprites.
extern char PLEX_YPOS[PLEX_COUNT];

// The sprite pointers for the multiplexed sprites
extern char PLEX_PTR[PLEX_COUNT];

// The address of the sprite pointers on the current screen (screen+0x3f8).
extern char* volatile PLEX_SCREEN_PTR;

// Indexes of the plex-sprites sorted by sprite y-position. Each call to plexSort() will fix the sorting if changes to the Y-positions have ruined it.
extern char PLEX_SORTED_IDX[PLEX_COUNT];

// Initialize the multiplexer data structures
void plexInit(char* screen);

// Set the address of the current screen used for setting sprite pointers (at screen+0x3f8)
inline void plexSetScreen(char* screen);

// Ensure that the indices in PLEX_SORTED_IDX is sorted based on the y-positions in PLEX_YPOS
// Assumes that the positions are nearly sorted already (as each sprite just moves a bit)
// Uses an insertion sort:
// 1. Moves a marker (m) from the start to end of the array. Every time the marker moves forward all elements before the marker are sorted correctly.
// 2a. If the next element after the marker is larger that the current element
//     the marker can be moved forwards (as the sorting is correct).
// 2b. If the next element after the marker is smaller than the current element:
//     elements before the marker are shifted right one at a time until encountering one smaller than the current one.
//      It is then inserted at the spot. Now the marker can move forward.
void plexSort();

// Show the next sprite.
// plexSort() prepares showing the sprites
void plexShowSprite();

// Get the y-position of the next sprite to show
inline char plexShowNextYpos();

// Prepare for a new frame. Initialize free to zero for all sprites.
inline void plexFreePrepare();

// Get the Y-position where the next sprite to be shown is free to use.
inline char plexFreeNextYpos();

// Update the data structure to reflect that a sprite has been shown. This sprite will be free again after 21 lines.
inline void plexFreeAdd(char ypos);