// 2-screen bitmap logo and a multiplexer scroller

#include <c64.h>
#include <6502.h>
#include <string.h>
#include "demo.h"
#include "byteboozer.h"

#pragma code_seg(CodePart2)
#pragma data_seg(DataPart2)

#include "vsp.h"
#define PLEX_SPRITE_PTRS 0xe3f8
#include "multiplex-bucket.h"

// Memory layout of the graphics bank
char * const LOGO_DATA          = (char*)0x5400;
char * const PART2_BITMAP       = (char*)0xc000; // -0xdfff
char * const PART2_SCREEN       = (char*)0xe000; // -0xe400
char * const PART2_SPRITES      = (char*)0xe400; // -0xf400
// Location PLEX ID updaters are placed when running
char * const PLEX_ID_UPDATERS   = (char*)0x3c00;
// Location where the crunched PLEX ID updaters are placed to be decrunched
char * const PLEX_ID_UPDATERS_CRUNCHED2 = (char*)0x7c00; // -0xFF72
// Size of the crunched PLEX ID updaters 
const unsigned int PLEX_ID_UPDATERS_CRUNCHED_SIZE = 0x0b72;
// Location where the crunched LOGO DATA is placed  to be decrunched
char * const LOGO_DATA_CRUNCHED2 = (char*)0x8800; // -0xAA2D
// Size of the crunched PLEX ID updaters 
const unsigned int LOGO_DATA_CRUNCHED_SIZE = 0x222d;

// Char-based sizes for the logo
const char LOGO_HEIGHT = 25;
const char LOGO_WIDTH = 80;

// Address of screen data
char * const LOGO_DATA_SCREEN = LOGO_DATA;
// Address of color data
char * const LOGO_DATA_COLORS = LOGO_DATA_SCREEN+LOGO_HEIGHT*LOGO_WIDTH;
// Address of pixel data
char * const LOGO_DATA_BITMAP = LOGO_DATA_COLORS+LOGO_HEIGHT*LOGO_WIDTH;

// Sprite pointer for sprite 0
#define SPRITE_0 toSpritePtr(PART2_SPRITES)

// The sprite font
#pragma data_seg(InitPart2)
char SPRITES_CRUNCHED[] = kickasm(resource "spritefont.png") {{
        .modify B2() {
            .pc = PART2_SPRITES "PART2_SPRITES"
	        .var p2_sprites = LoadPicture("spritefont.png", List().add($000000, $ffffff))
	        .for(var sy=0;sy<8;sy++) {
    		    .for(var sx=0;sx<8;sx++) {
    	    	    .for (var y=0;y<21; y++) {
	    	    	    .for (var c=0; c<3; c++) {
    	                	.byte p2_sprites.getSinglecolorByte(sx*3+c,sy*21+y)
	                    }
	                }
	    	        .byte 0
	  	        }
	        }
        }
}};
#pragma data_seg(DataPart2)

#pragma data_seg(InitPart2)
char LOGO_DATA_CRUNCHED[] = kickasm(resource "logo-bitmap-640.png", resource "mcbitmap.asm", uses LOGO_HEIGHT, uses LOGO_WIDTH) {{
        .modify B2() {
            .pc = LOGO_DATA "LOGO DATA"
            #import "mcbitmap.asm"
            .var mcBmmData2 = getMcBitmapData(LoadPicture("logo-bitmap-640.png"))    
            // Screen data
            .for (var y=0; y<LOGO_HEIGHT; y++)
                .for (var x=0; x<LOGO_WIDTH; x++)
                    .byte getMcScreenData(x, y, mcBmmData2)
            // Color Data
            .for (var y=0; y<LOGO_HEIGHT; y++)
                .for (var x=0; x<LOGO_WIDTH; x++)
                    .byte getMcColorData(x, y, mcBmmData2)
            // Bitmap Data (row by row)
            .for (var y=0; y<LOGO_HEIGHT; y++)
                .for (var i=0; i<8; i++)
                    .for (var x=0; x<LOGO_WIDTH; x++)
                        .byte getMcPixelData(x, y, i, mcBmmData2)
        }
}};
#pragma data_seg(DataPart2)

// A sinus table with values [0;320]
__align(0x100) unsigned int VSP_SINTABLE[0x100] = kickasm {{
    .fillword $100, round(160+160*sin(2*PI*i/256))
}};

// The sequence of colors for the sprites
char SPRITE_COLOR_SEQUENCE[] = {
    WHITE,  WHITE,  WHITE,  WHITE,  WHITE,  WHITE,  WHITE,  WHITE,  WHITE,  WHITE,
    WHITE,  WHITE,  WHITE,  WHITE,  WHITE,  WHITE,  WHITE,  WHITE,  WHITE,  WHITE,  WHITE,  WHITE,
    WHITE,  WHITE,  WHITE,  WHITE,  WHITE,  WHITE,  WHITE,  WHITE,  WHITE,  WHITE,  WHITE,  WHITE,
    WHITE,  YELLOW, CYAN,   GREEN,  PURPLE, RED,    BLUE,   RED,    PURPLE, GREEN,  CYAN,   YELLOW, 
    WHITE,  WHITE,  
};

__align(0x100) char SCROLL_YSIN[0x100] = kickasm {{
    .fill $100, round(139+89.5*sin(toRadians(360*i/256)))
}};

// The buckets containing sprites to show. 8 sprites in each bucket.
__align(0x100) struct BucketSprite BUCKET_SPRITES[FRAME_COUNT*BUCKET_COUNT*BUCKET_SIZE];

// Copy of the original buckets containing sprites to show. 8 sprites in each bucket. (Used for adding the plex_id_offset)
__align(0x100) struct BucketSprite ORIGINAL_BUCKET_SPRITES[FRAME_COUNT*BUCKET_COUNT*BUCKET_SIZE];

__align(0x100) char XMOVEMENT[0x400] = kickasm {{
    //.lohifill $100, round(344-i*344/$100-86*sin(toRadians(360*i/$100)))
    .lohifill $200, round(344-i*344/$100-129*sin(toRadians(360*i/$100)))
    //.lohifill $100, round(344-i*344/$100-86*sin(toRadians(360*i/$80)))
    //.lohifill $100, round(344-i*344/$100 -86*sin(toRadians(360*i/$100)) -43*sin(toRadians(360*i/$80)))
    //.lohifill $100, 344-i*344/$100
}};

// The high-value table
char * const XMOVEMENT_HI = XMOVEMENT+0x200;

// The scroll text
char SCROLL_TEXT[] = 
   "\x2a "
   "most people will remember 2020 for a long time. "
   "for us nerds, it was a chance to dig deep into our hobbies. "
   "but we do miss the demoparties, and drinking beers with you crazy people... "
   "it is the 30th birthday of camelot, and this virtual greeting card is our way of celebrating with all of you! "
   "    credits  "
   "\x2a  code: rex  "
   "\x2a  music: linus  "
   "\x2a  graphics: bizkid, snabel & vic  "
   "\x2a    "
   "camelot sends love to "
   "\xff  abyss connection  "
   "\xff  algotech  "
   "\xff  ancients  "
   "\xff  arsenic  "
   "\xff  arise  "
   "\xff  artline designs  "
   "\xff  artstate  "
   "\xff  atlantis  "
   "\xff  bonzai  "
   "\xff  booze design  "
   "\xff  censor design  "
   "\xff  cosine  "
   "\xff  crest  "
   "\xff  chorus  "
   "\xff  dekadence  "
   "\xff  delysid  "
   "\xff  desire  "
   "\xff  elysium  "
   "\xff  excess  "
   "\xff  extend  "
   "\xff  faic  "
   "\xff  f4cg  "
   "\xff  fairlight  "
   "\xff  fossil  "
   "\xff  glance  "
   "\xff  genesis project  "
   "\xff  haujobb  "
   "\xff  hitmen  "
   "\xff  hoaxers  "
   "\xff  hokuto force  "
   "\xff  horizon  "
   "\xff  illusion  "
   "\xff  john dillermand  "
   "\xff  laxity  "
   "\xff  lepsi de  "
   "\xff  lethargy  "
   "\xff  mayday  "
   "\xff  megastyle  "
   "\xff  multistyle labs  "
   "\xff  nah-kolor  "
   "\xff  noice  "
   "\xff  offence  "
   "\xff  onslaught  "
   "\xff  oxyron  "
   "\xff  padua  "
   "\xff  panda design  "
   "\xff  panoramic designs  "
   "\xff  performers  "
   "\xff  plush  "
   "\xff  pretzel logic  "
   "\xff  prosonix  "
   "\xff  proxima  "
   "\xff  rabenauge  "
   "\xff  radwar  "
   "\xff  rebels  "
   "\xff  resource  "
   "\xff  samar  "
   "\xff  scenesat  "
   "\xff  shape  "
   "\xff  siesta  "
   "\xff  silicon ltd.  "
   "\xff  singular  "
   "\xff  software of sweden  "
   "\xff  starion  "
   "\xff  success  "
   "\xff  svenonacid  "
   "\xff  the dreams  "
   "\xff  the solution  "
   "\xff  triad  "
   "\xff  tropyx  "
   "\xff  trsi  "
   "\xff  unicess  "
   "\xff  up rough  "
   "\xff  vision  "
   "\xff  xenon  "
   "\xff  xentax  "
   "\xff  "
   "... we hope to see you all again in 2021..."
   "                                "
    ;

// IRQ performing the VSP
const char IRQ_SWING_VSP_LINE = 0x2d;

void part2_init() {
    // Decrunch sprites
    byteboozer_decrunch(SPRITES_CRUNCHED);
    // Move the crunched logo data out of harms way
    memcpy(LOGO_DATA_CRUNCHED2, LOGO_DATA_CRUNCHED, LOGO_DATA_CRUNCHED_SIZE);
    // Move the crunched plex updaters out of harms way
    memcpy(PLEX_ID_UPDATERS_CRUNCHED2, PLEX_ID_UPDATERS_CRUNCHED, PLEX_ID_UPDATERS_CRUNCHED_SIZE);
    // Decrunch multiplexer frame updaters (from new location)
    byteboozer_decrunch(PLEX_ID_UPDATERS_CRUNCHED2);
    // Decrunch logo data
    byteboozer_decrunch(LOGO_DATA_CRUNCHED2);

    // Empty the hidden part of the bitmap   
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_ALL;
    memset(PART2_BITMAP+8000, 0, 192);
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;

    // Empty screen & cols
    memset(COLS, BLACK, 1024);
    memset(PART2_SCREEN, BLACK, 1000);

    // Fade the sparkler
    VICII->SPRITE0_COLOR = GREY; 
    VICII->SPRITES_MCOLOR1 = BROWN;
    VICII->SPRITES_MCOLOR2 = BLUE;

    // Initialize PLEX tables
    plexPrepareInit();
    // Prepare 8 frames of y-positions into BUCKET_SPRITES
    struct BucketSprite* frame = BUCKET_SPRITES;
    for(char frame_idx=0;frame_idx<8;frame_idx++) {
        char sin_idx = frame_idx;
        for(char s=0; s<PLEX_COUNT;s++) {
            PLEX_YPOS[s] = SCROLL_YSIN[sin_idx];            
            sin_idx += 8;
        }
        // Perform bucket sort
        plexPrepareFrame(frame);
        // Move to Next frame
        frame += BUCKET_SIZE*BUCKET_COUNT;
    }
    // Copy the original buckets 
    memcpy(ORIGINAL_BUCKET_SPRITES, BUCKET_SPRITES, sizeof(BUCKET_SPRITES));
    // Set the initial sprite pointers
    for(char s=0;s<PLEX_COUNT;s++) {
        PLEX_PTR[s] = SPRITE_0+' ';
    }
    // Disable sparkler
    VICII->SPRITES_XMSB = 0x00;
    VICII->SPRITE0_X = 0x00;
    VICII->SPRITES_ENABLE = 0x00;
    // Set sprite colors
    VICII->SPRITES_MC = 0x00;
    for(char s=0;s<8;s++) 
        SPRITES_COLOR[s] = WHITE;

    // Empty the rest of the screen    
    memset(PART2_SCREEN+1000, BLACK, 24); 

}

void part2_run() {
    SEI();
    // Colors
    VICII->BORDER_COLOR = BLACK;
    VICII->BG_COLOR = BLACK;
    // Change graphics bank
    CIA2->PORT_A = toDd00(PART2_SCREEN);
    // Show screen
    VICII->MEMORY = toD018(PART2_SCREEN, PART2_BITMAP);
    // Set bitmap mode
    VICII->CONTROL1 |= VICII_BMM;
    // Enable & initialize sprites
    *SPRITES_ENABLE = 0xff;
    // Disable CIA 1 Timer IRQ
    CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR;
    // Acknowledge any timer IRQ
    asm { lda CIA1_INTERRUPT }
    // Acknowledge any VIC IRQ
    *IRQ_STATUS = 0x0f;
    // Set raster line to first bucket
    *VICII_CONTROL1 &=0x7f;
    *RASTER = BUCKET_YPOS[0];
    // Enable Raster Interrupt
    *IRQ_ENABLE = IRQ_RASTER;
    // Set the IRQ routine
    *HARDWARE_IRQ = &irq_swing_top;
    // Enable the IRQ again
    CLI();

    // The current frame ID (0-7)
    plex_frame_id = 0;
    // Pointer to the buckets of the current frame
    plex_frame = BUCKET_SPRITES;
    // Offset added to plex_id to ensure the sprite cycling works (decreased 1 every time a cycle is complete)
    plex_id_offset = 0;

    part2_loop();

}

// Part 2 main loop
void part2_loop() {
    p2_work_ready = 0;
    for(;;)  {
        while(p2_work_ready==0) ;
        // Play music
        demo_work();
        // Reveal logo 
        if(p2_logo_revealing && !p2_logo_reveal_done)
            p2_logo_reveal();
        // Show logo at 0:18,50
        if(!p2_logo_revealing && demo_frame_count>18*50+25)
            p2_logo_revealing = 1;
        // Move logo as soon as reveal is done (40 frames) 0:19,30
        if(!p2_logo_swinging && p2_logo_reveal_done)
            p2_logo_swinging = 1;
        // Start plex scroller at 0:26
        if(!p2_plex_scroller_moving && demo_frame_count>26*50)
            p2_plex_scroller_moving = 1;
        // My work is done!
        p2_work_ready = 0;
    }    
}

// Signals the main() loop to do work when all rasters are complete
volatile char p2_work_ready;

// 1 if the logo is being revealed
volatile char p2_logo_revealing = 0;

// 1 if the logo is completely revealed
volatile char p2_logo_reveal_done = 0;

// 1 if the logo is being showed
volatile char p2_logo_swinging = 0;

// 1 if the scroll is moving
volatile char p2_plex_scroller_moving = 0;

// Number of columns shown of the logo
volatile char p2_logo_reveal_idx = 0;

// Reveals the logo column by column
void p2_logo_reveal() {
    if(p2_logo_reveal_idx>=40)
        p2_logo_reveal_done = 1;
    else 
        vsp_update_screen(p2_logo_reveal_idx++);
}

// X-movement index
volatile char x_movement_idx = 0;
// The next char to use from the scroll text
char* volatile scroll_text_next = SCROLL_TEXT;

// Scroll the plex sprites to the left.
void plex_scroller_move() {
        char x_idx = x_movement_idx;
        for(char s=0; s<PLEX_COUNT;s++) {
            PLEX_XPOS[s] = XMOVEMENT[x_idx];
            PLEX_XPOS_MSB[s] = XMOVEMENT_HI[x_idx];
            if(x_idx==0) {
                // Page boundary crossed - new scroll char! Detection is a bit flaky!
                // Restart scroll text of needed
                if(*scroll_text_next==0x00)
                    scroll_text_next = SCROLL_TEXT;
                // Read next char from the scroll text
                char letter = *scroll_text_next++;
                // If the letter is \xff then add a heart
                if(letter==0xff) 
                    letter = 0x00;
                // Add the letter
                PLEX_PTR[s] = SPRITE_0+letter;
             }
            x_idx +=8;
        }
        x_movement_idx++;
}

// The current frame ID (0-7)
volatile char plex_frame_id = 0;
// Pointer to the buckets of the current frame
struct BucketSprite* volatile plex_frame = BUCKET_SPRITES;
// Offset added to plex_id to ensure the sprite cycling works (decreased 1 every time a cycle is complete)
volatile char plex_id_offset = 0;
// Pointer to the current bucket of the current frame
struct BucketSprite* volatile plex_bucket = BUCKET_SPRITES;
// Index of the current bucket in the current frame (0..BUCKET_COUNT-1)
volatile char plex_bucket_id = 0;

// Inititialize plex frame and show first bucket
__interrupt void irq_swing_top() {
    //*BORDER_COLOR = DARK_GREY;
    //VICII->BORDER_COLOR++;
    // Initialize the multiplexer frame
    plexFrameStart();
    plex_bucket = plex_frame;
    plex_bucket_id = 0;
    // Show the first bucket
    plexBucketShow(plex_bucket);
    // Move forward to the next bucket
    plex_bucket += BUCKET_SIZE;
    plex_bucket_id++;
    // Acknowledge the IRQ
    *IRQ_STATUS = IRQ_RASTER;
    // Set up the VSP IRQ
    *HARDWARE_IRQ = &irq_swing_vsp;
    *RASTER = IRQ_SWING_VSP_LINE;    
    //*BORDER_COLOR = BLACK;
    //VICII->BORDER_COLOR--;
}

// The fine scroll (0-7)
volatile char vsp_fine_scroll;
// The coarse scroll (0-40)
volatile char vsp_coarse_scroll;

// Show sprites from the multiplexer, rescheduling the IRQ as many times as needed
__interrupt void irq_swing_vsp() {
    // Perform VSP scrolling of the screen (must be the first call in the IRQ)
    vsp_perform();
    // Set BMM
    VICII->CONTROL1 |= VICII_BMM;
    // Set fine scroll (and MCM)
    VICII->CONTROL2 = vsp_fine_scroll | VICII_MCM;

    //*BORDER_COLOR = DARK_GREY;
    // Acknowledge the IRQ
    *IRQ_STATUS = IRQ_RASTER;
    // Set up the PLEX IRQ (handles the rest of the multiplexer buckets)
    *HARDWARE_IRQ = &irq_swing_plex;
    *RASTER = BUCKET_YPOS[1];
    //*BORDER_COLOR = BLACK;
}

// Index into the VSP sinus value
volatile char vsp_sin_idx = 0x40;

// Index into the sprite color sequence
volatile char sprite_color_idx = 0;

// Show sprites from the multiplexer, rescheduling the IRQ for each bucket
__interrupt void irq_swing_plex() {
    //*BORDER_COLOR = DARK_GREY;
    // Show the bucket
    plexBucketShow(plex_bucket);
    // Move forward to the next bucket
    plex_bucket += BUCKET_SIZE;
    plex_bucket_id++;
    if(plex_bucket_id<BUCKET_COUNT) {
        // Not done with the frame yet - set up the next PLEX IRQ (handles the rest of the multiplexer buckets)
        *HARDWARE_IRQ = &irq_swing_plex;
        *RASTER = BUCKET_YPOS[plex_bucket_id];
        //*BORDER_COLOR = BLACK;
    } else {
        // We are done with this frame - finish it and perform other stuff!
        //VICII->BORDER_COLOR = RED;
        // Set up the TOP IRQ
        *HARDWARE_IRQ = &irq_swing_top;
        *RASTER = BUCKET_YPOS[0];          

        // Move to the next frame of the plexer
        const char YMOVE = 3;
        plex_frame_id += YMOVE;
        plex_frame += (unsigned int)YMOVE*BUCKET_COUNT*BUCKET_SIZE;
        if(plex_frame_id>=FRAME_COUNT) {
            // Reset to start of cycle 
            plex_frame -= BUCKET_COUNT*BUCKET_SIZE*FRAME_COUNT;
            plex_frame_id -= FRAME_COUNT;
            // And change the PLEX ID offset
            plex_id_offset--;
        }
        // Update plex_id in the next frame
        //VICII->BORDER_COLOR = BLUE;
        update_frame_plex_id_offset(plex_frame_id);

        if(p2_logo_swinging) {
            // Update the VSP value with a sinus
            unsigned int scroll = VSP_SINTABLE[(unsigned int)(vsp_sin_idx++)];
            vsp_fine_scroll = (char)scroll&7;
            char new_coarse_scroll = (char)(scroll/8);
            // Update the VSP value with a sinus
            char coarse_scroll_diff = vsp_coarse_scroll - new_coarse_scroll;
            // Update screen column (if needed)
            if(coarse_scroll_diff==0x01) {
                // Moving left - put a new column at the right border
                char x_offset = 0x50-vsp_coarse_scroll;
                // Only move 24 - because the last line is empty (and holds sprite pointers)
                vsp_update_screen(x_offset);
            } else if(coarse_scroll_diff==0xff) {
                // Moving right - put a new column at the left border
                char x_offset = 0x27-vsp_coarse_scroll;
                vsp_update_screen(x_offset);
                // Clear line 25 - because the start of the last line was over-written by line #24 chars 40-80
                (PART2_SCREEN+24*40)[x_offset] = 0; //(LOGO_DATA_SCREEN+24*80)[x_offset];
                (COLS+24*40)[x_offset] = 0;  //(LOGO_DATA_COLORS+24*80)[x_offset];
            }
            vsp_coarse_scroll = new_coarse_scroll;
            vsp_scroll = 40-vsp_coarse_scroll;
        }

        // Move the sprites (X-position & new scroll chars)
        if(p2_plex_scroller_moving) {
            plex_scroller_move();
            // Change sprite colors
            if(++sprite_color_idx == sizeof(SPRITE_COLOR_SEQUENCE)) sprite_color_idx = 0;        
            for(char s=0;s<8;s++) 
                SPRITES_COLOR[s] = SPRITE_COLOR_SEQUENCE[sprite_color_idx];
        }

        // Signal the main routine
        p2_work_ready = 1;

    }
    // Acknowledge the IRQ
    *IRQ_STATUS = IRQ_RASTER;
}

// Update the plex_id's of a multiplexer frame to reflect a specific plex_id_offset
void update_frame_plex_id_offset(char plex_frame_id) {
    unsigned int* jmp_table = (unsigned int*)PLEX_ID_UPDATERS;
    unsigned int jmp_address = jmp_table[plex_frame_id];
    kickasm(uses jmp_address) {{
        lda jmp_address
        sta call+1
        lda jmp_address+1
        sta call+2
        call: jsr $0000
    }}
}

// Unrolled ASM  to update plex_id_offset for FRAMES 0-7
#pragma data_seg(InitPart2)
char PLEX_ID_UPDATERS_CRUNCHED[] = kickasm(uses ORIGINAL_BUCKET_SPRITES, uses BUCKET_SPRITES, uses plex_id_offset) {{
    .modify B2() {
        .pc = PLEX_ID_UPDATERS "PLEX_ID_UPDATERS"
        // First generate a jump table
        .for(var frame=0;frame<8;frame++) 
            .word updaters[frame].updater
        // Generate the 8 unrolled updaters
        updaters: 
        .for(var frame=0;frame<8;frame++) {
            updater:
            ldx #$1f
            .for(var sprite=0; sprite<9*8; sprite++ ) {
                lda ORIGINAL_BUCKET_SPRITES + frame*8*9*2 + sprite*2 +1
                clc
                adc plex_id_offset
                sax BUCKET_SPRITES + frame*8*9*2 + sprite*2 +1
            }
            rts        
        }
    }
}};
#pragma data_seg(DataPart2)

// Update screen, colors and bitmap with a single column of new data
// - x_offset is the offset of the column to update (0-79)
void vsp_update_screen(__ma char x_offset) {
    // Update screen and colors
    kickasm(uses x_offset, uses PART2_SCREEN, uses COLS,uses LOGO_DATA, uses LOGO_DATA_COLORS, clobbers "AX") {{
        ldx x_offset
        .for(var row=0;row<24;row++) {
            lda LOGO_DATA+80*row,x
            sta PART2_SCREEN+40*row,x
            lda LOGO_DATA_COLORS+80*row,x
            sta COLS+40*row,x
        }
    }}
    // Disable I/O (BITMAP is below I/O)
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_ALL;
    // Update bitmap (using 3 routines to handle all bitmap columns)
    unsigned int x_offset8 = (unsigned int)x_offset*8;
    if(BYTE1(x_offset8) == 0) {
        kickasm(uses x_offset, uses x_offset8, uses PART2_BITMAP, uses LOGO_DATA_BITMAP, clobbers "AXY") {{
            ldx x_offset
            ldy x_offset8
            .for(var row=0;row<24;row++)
                .for(var pix=0;pix<8;pix++) {
                    lda LOGO_DATA_BITMAP+80*(row*8+pix),x
                    sta PART2_BITMAP+row*40*8+pix,y
                }
        }}
    } else if(BYTE1(x_offset8) == 1) {
        kickasm(uses x_offset, uses x_offset8, uses PART2_BITMAP, uses LOGO_DATA_BITMAP, clobbers "AXY") {{
            ldx x_offset
            ldy x_offset8
            .for(var row=0;row<24;row++)
                .for(var pix=0;pix<8;pix++) {
                    lda LOGO_DATA_BITMAP+80*(row*8+pix),x
                    sta PART2_BITMAP+$100+row*40*8+pix,y
                }
        }}
    } else { // >x_offset8 == 2
        kickasm(uses x_offset, uses x_offset8, uses PART2_BITMAP, uses LOGO_DATA_BITMAP, clobbers "AXY") {{
            ldx x_offset
            ldy x_offset8
            .for(var row=0;row<24;row++)
                .for(var pix=0;pix<8;pix++) {
                    lda LOGO_DATA_BITMAP+80*(row*8+pix),x
                    sta PART2_BITMAP+$200+row*40*8+pix,y
                }
        }}
    }
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
}