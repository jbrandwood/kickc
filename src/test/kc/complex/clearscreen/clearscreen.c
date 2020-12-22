// Clears start screen throwing around the letters (by turning them into sprites)
#include <stdlib.h>
#include <sqr.h>
#include <atan2.h>
#include <multiply.h>
#include <c64.h>

// Generate debug code (raster time usage etc.)
const bool DEBUG = false;

// Address of the screen
byte* const SCREEN = 0x0400;
// Sprite data for the animating sprites
byte* const SPRITE_DATA = 0x2000;
// Values added to VX
const unsigned int VXSIN[40] = kickasm {{
  .for(var i=0; i<40; i++) {
      .word -sin(toRadians([i*360]/40))*4
    }
}};

// Values added to VY
const unsigned int VYSIN[25] = kickasm {{
  .for(var i=0; i<25; i++) {
      .word -sin(toRadians([i*360]/25))*4
    }
}};

// Copy of the screen used for finding chars to process
byte* SCREEN_COPY = malloc(1000);

// Screen containing bytes representing the distance to the center
byte* SCREEN_DIST = malloc(1000);

// Max number of chars processed at once
const byte NUM_PROCESSING = 8;

// Struct holding char being processed
struct ProcessingChar {
    // x-position (0-39)
    char x;
    // y-position (0-24)
    char y;
    // squared distance to center (0-569)
    char dist;
};

// Distance value meaning not found
const byte NOT_FOUND = 0xff;

// Struct holding sprite being processed
struct ProcessingSprite {
    // sprite x-position. Fixed point [12.4]. Values (24-336)
    unsigned int x;
    // sprite y-position. Fixed point [12.4]. Values (30-228)
    unsigned int y;
    // sprite x velocity. Fixed point [12.4]
    unsigned int vx;
    // sprite y velocity. Fixed point [12.4]
    unsigned int vy;
    // sprite ID (0-7)
    char id;
    // sprite pointer (0-255)
    char ptr;
    // sprite color
    char col;
    // status of the processing
    enum { STATUS_FREE, STATUS_NEW, STATUS_PROCESSING } status;
    // Pointer to screen char being processed (used for deletion)
    char* screenPtr;
};

// Sprites currently being processed in the interrupt
struct ProcessingSprite PROCESSING[NUM_PROCESSING];

void main() {
    // Initialize the screen containing distance to the center
    init_angle_screen(SCREEN_DIST);
    // Copy screen to screen copy
    for( char *src=SCREEN, *dst=SCREEN_COPY; src!=SCREEN+1000; src++, dst++) *dst = *src;
    // Init processing array
    for( char i: 0..NUM_PROCESSING-1 ) PROCESSING[i] = { 0, 0, 0, 0, 0, 0, 0, STATUS_FREE, 0};
    // Init sprites
    initSprites();
    // Set-up raster interrupts
    setupRasterIrq(RASTER_IRQ_TOP, &irqTop);
    // Main loop
    do {
        // Look for the non-space closest to the screen center
        struct ProcessingChar center = getCharToProcess();
        if(center.dist==NOT_FOUND)
            break;
        startProcessing(center);
    } while(true);
    (*(SCREEN+999)) = '.';
    do {
        (*(COLS+999))++;
    } while (true);
}

// Find the non-space char closest to the center of the screen
// If no non-space char is found the distance will be 0xffff
struct ProcessingChar getCharToProcess() {
    struct ProcessingChar closest = { 0, 0, NOT_FOUND };
    char* screen_line = SCREEN_COPY;
    char* dist_line = SCREEN_DIST;
    for( char y: 0..24) {
        for( char x: 0..39) {
            if(screen_line[x]!=' ') {
                char dist = dist_line[x];
                if(dist<closest.dist) {
                    // Update closest char
                    closest = { x, y, dist };
                }
            }
        }
        screen_line += 40;
        dist_line += 40;
    }
    if(closest.dist != NOT_FOUND) {
        // clear the found char on the screen copy
        *(SCREEN_COPY+(unsigned int)closest.y*40+closest.x) = ' ';
    }
    return closest;
}

// Start processing a char - by inserting it into the PROCESSING array
void startProcessing(struct ProcessingChar center) {
    // Busy-wait while finding an empty slot in the PROCESSING array
    char freeIdx = 0xff;
    do {
        for( char i: 0..NUM_PROCESSING-1 ) {
            if(PROCESSING[i].status==STATUS_FREE) {
                freeIdx = i;
                break;
            }
        }
    } while (freeIdx==0xff);
    // Found a free sprite
    char spriteIdx = freeIdx;
    // Copy char into sprite
    unsigned int offset = (unsigned int)center.y*40+center.x;
    char* colPtr = COLS+offset;
    char spriteCol = *colPtr;
    char* screenPtr = SCREEN+offset;
    char* spriteData = SPRITE_DATA+(unsigned int)spriteIdx*64;
    char ch = (*screenPtr);
    char* chargenData = CHARGEN+(unsigned int)ch*8;
    asm { sei }
    *PROCPORT = PROCPORT_RAM_CHARROM;
    for( char i: 0..7) {
        *spriteData = *chargenData;
        spriteData += 3;
        chargenData++;
    }
    *PROCPORT = PROCPORT_RAM_IO;
    asm { cli }
    unsigned int spriteX = (BORDER_XPOS_LEFT + (unsigned int)center.x*8) << 4;
    unsigned int spriteY = (BORDER_YPOS_TOP + (unsigned int)center.y*8) << 4;
    char spritePtr = (char)(SPRITE_DATA/64)+spriteIdx;
    // Put the sprite into the PROCESSING array
    PROCESSING[spriteIdx] = { spriteX, spriteY, (unsigned int)(spriteIdx*8), 60, spriteIdx, spritePtr, spriteCol, STATUS_NEW, screenPtr };
}

const unsigned int XPOS_LEFTMOST = (unsigned int)(BORDER_XPOS_LEFT-8)<<4;
const unsigned int XPOS_RIGHTMOST = (unsigned int)(BORDER_XPOS_RIGHT)<<4;
const unsigned int YPOS_TOPMOST = (unsigned int)(BORDER_YPOS_TOP-8)<<4;
const unsigned int YPOS_BOTTOMMOST = (unsigned int)(BORDER_YPOS_BOTTOM)<<4;


// Process any chars in the PROCESSING array
void processChars() {
    char numActive = 0;
    for( char i: 0..NUM_PROCESSING-1 ) {
        struct ProcessingSprite* processing = PROCESSING+i;
        char bitmask = 1<<processing->id;
        if(processing->status!=STATUS_FREE) {
            if(processing->status==STATUS_NEW) {
                // Clear the char on the screen
                *(processing->screenPtr) = ' ';
                // Enable the sprite
                *SPRITES_ENABLE |= bitmask;
                // Set the sprite color
                SPRITES_COLOR[processing->id] = processing->col;
                // Set sprite pointer
                *(SCREEN+SPRITE_PTRS+processing->id) = processing->ptr;
                // Set status
                processing->status = STATUS_PROCESSING;
            }
            unsigned int xpos = processing->x >> 4;
            // Set sprite position
            if(>xpos) {
                *SPRITES_XMSB |= bitmask;
            } else {
                *SPRITES_XMSB &= 0xff ^ bitmask;
            }
            SPRITES_XPOS[i*2] = (char)xpos;
            char ypos = (char)(processing->y>>4);
            SPRITES_YPOS[i*2] = ypos;

            // Move sprite
            if(processing->x < XPOS_LEFTMOST || processing->x > XPOS_RIGHTMOST || processing->y < YPOS_TOPMOST|| processing->y > YPOS_BOTTOMMOST  ) {
                // Set status to FREE
                processing->status = STATUS_FREE;
                // Disable the sprite
                *SPRITES_ENABLE &= 0xff ^ bitmask;
            } else {
                char xchar = (char)(xpos/8) - BORDER_XPOS_LEFT/8;
                processing->vx += VXSIN[xchar];
                processing->x += processing->vx;
                char ychar = (char)(ypos/8) - BORDER_YPOS_TOP/8;
                processing->vy +=   VYSIN[ychar];
                processing->y += processing->vy;
            }
            numActive++;
        }
    }
    if(DEBUG) {
        *(SCREEN+999) = '0'+numActive;
    }
}

// Populates 1000 chars (a screen) with values representing the distance to the center.
// The actual value stored is distance*2 to increase precision
void init_dist_screen(char* screen) {
    NUM_SQUARES = 0x30;
    init_squares();
    char* screen_topline = screen;
    char *screen_bottomline = screen+40*24;
    for(char y: 0..12) {
        char y2 = y*2;
        char yd = (y2>=24)?(y2-24):(24-y2);
        unsigned int yds = sqr(yd);
        for( char x=0,xb=39; x<=19; x++, xb--) {
            char x2 = x*2;
            char xd = (x2>=39)?(x2-39):(39-x2);
            unsigned int xds = sqr(xd);
            unsigned int ds = xds+yds;
            char d = sqrt(ds);
            screen_topline[x] = d;
            screen_bottomline[x] = d;
            screen_topline[xb] = d;
            screen_bottomline[xb] = d;
        }
        screen_topline += 40;
        screen_bottomline -= 40;
    }
}

// Populates 1000 chars (a screen) with values representing the angle to the center.
// Utilizes symmetry around the  center
void init_angle_screen(char* screen) {
    char* screen_topline = screen+40*12;
    char *screen_bottomline = screen+40*12;
    for(char y: 0..12) {
        for( char x=0,xb=39; x<=19; x++, xb--) {
            signed int xw = (signed int)(unsigned int){ 39-x*2, 0 };
            signed int yw = (signed int)(unsigned int){ y*2, 0 };
            unsigned int angle_w = atan2_16(xw, yw);
            char ang_w = >(angle_w+0x0080);
            screen_bottomline[xb] = ang_w;
            screen_topline[xb] = -ang_w;
            screen_topline[x] = 0x80+ang_w;
            screen_bottomline[x] = 0x80-ang_w;
        }
        screen_topline -= 40;
        screen_bottomline += 40;
    }
}

// Initialize sprites
void initSprites() {
    // Clear sprite data
    for( char* sp = SPRITE_DATA; sp<SPRITE_DATA+NUM_PROCESSING*64; sp++) *sp = 0;
    // Initialize sprite registers
    for( char i: 0..7) {
        SPRITES_COLOR[i] = LIGHT_BLUE;
    }
    *SPRITES_MC = 0;
    *SPRITES_EXPAND_X = 0;
    *SPRITES_EXPAND_Y = 0;
}

// Setup Raster IRQ
void setupRasterIrq(unsigned int raster, void()* irqRoutine) {
    asm { sei }
    // Disable kernal & basic
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
    // Disable CIA 1 Timer IRQ
    CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR;
    if(raster<0x100) {
        *VIC_CONTROL &=0x7f;
    } else {
        *VIC_CONTROL |=0x80;
    }
    *RASTER = <raster;
    // Enable Raster Interrupt
    *IRQ_ENABLE = IRQ_RASTER;
    // Set the IRQ routine
    *HARDWARE_IRQ = irqRoutine;
    asm { cli }
}

const char RASTER_IRQ_TOP = 0x30;

// Raster Interrupt at the top of the screen
__interrupt(hardware_clobber) void irqTop() {
    if(DEBUG) {
        for( char i: 0..4) {}
        *BORDER_COLOR = WHITE;
        *BG_COLOR = WHITE;
        for( char i: 0..7) {}
        *BORDER_COLOR = LIGHT_BLUE;
        *BG_COLOR = BLUE;
    }

    // Trigger IRQ at the middle of the screen
    *RASTER = RASTER_IRQ_MIDDLE;
    *HARDWARE_IRQ = &irqBottom;
    // Acknowledge the IRQ
    *IRQ_STATUS = IRQ_RASTER;
}

const char RASTER_IRQ_MIDDLE = 0xff;

// Raster Interrupt at the bottom of the screen
__interrupt(hardware_clobber) void irqBottom() {
    if(DEBUG) {
        for( char i: 0..4) {}
        *BORDER_COLOR = WHITE;
        *BG_COLOR = WHITE;
    }
    processChars();
    if(DEBUG) {
        *BORDER_COLOR = LIGHT_BLUE;
        *BG_COLOR = BLUE;
    }

    // Trigger IRQ at the top of the screen
    *RASTER = RASTER_IRQ_TOP;
    *HARDWARE_IRQ = &irqTop;
    // Acknowledge the IRQ
    *IRQ_STATUS = IRQ_RASTER;
}