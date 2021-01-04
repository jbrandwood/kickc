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

// The number of sprites in the multiplexer
#define PLEX_COUNT 32
// The number of sprites per multiplexer bucket
#define BUCKET_SIZE 8
// The number of multiplexer buckets per frame
#define BUCKET_COUNT 9
// The number of multiplexer frames
#define FRAME_COUNT 8

// The Y-position (IRQ raster line) starting each bucket
extern char BUCKET_YPOS[BUCKET_COUNT];

// The y-positions of the multiplexer sprites. (These are converted to multiplexer buckets)
extern char PLEX_YPOS[PLEX_COUNT];

// The low byte of the x-positions of the multiplexer sprites 
extern char PLEX_XPOS[PLEX_COUNT];

// The MSB of the x-positions of the multiplexer sprites (0/1)
extern char PLEX_XPOS_MSB[PLEX_COUNT];

// The sprite pointers for the multiplexed sprites
extern char PLEX_PTR[PLEX_COUNT];

// The sprite color for the multiplexed sprites
//extern char PLEX_COL[PLEX_COUNT];

// A single sprite in a multiplexer bucket
struct BucketSprite {
    char ypos;
    char plex_id;
};

// Initialize data structures for the multiplexer
void plexPrepareInit();

// Performs run-time bucket sort of the sprites in the PLEX_ arrays into struct BucketSprite[]
// Starts by performing a true sorting of the sprites based on Y-position (using insertion sort)
void plexPrepareFrame(struct BucketSprite* frame);

// Start a new frame (initializing data structures)
void plexFrameStart();

// Show the sprites in a specific bucket
// - bucketSprites: The bucket to show
void plexBucketShow(struct BucketSprite* bucket);

// Updates the PLEX_ID's preparing for the next cycle of the multiplexer.
// Performs: sprite->plex_id=(sprite->plex_id-1)&(FRAME_COUNT-1)
void plexFrameEnd(struct BucketSprite* frame);
