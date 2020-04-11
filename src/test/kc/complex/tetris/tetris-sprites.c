// Tetris Game for the Commodore 64
// A sprite multiplexer covering the playfield with a black layer to allow for 3 single-pixel colors
#include <c64.h>
#include "tetris-data.c"

kickasm(pc PLAYFIELD_SPRITES, resource "playfield-sprites.png") {{
	.var sprites = LoadPicture("playfield-sprites.png", List().add($010101, $000000))
	// Put the sprites into memory 
	.for(var sy=0;sy<10;sy++) {
	    .var sprite_gfx_y = sy*20
		.for(var sx=0;sx<3;sx++) {
	    	.for (var y=0;y<21; y++) {
	    	    .var gfx_y =  sprite_gfx_y + mod(2100+y-sprite_gfx_y,21)
		    	.for (var c=0; c<3; c++) {
	            	.byte sprites.getSinglecolorByte(sx*3+c,gfx_y)
	            }
	        }
	    	.byte 0
	  	}
	}
}}

// Setup the sprites
void sprites_init() {
    *SPRITES_ENABLE = %00001111;
    *SPRITES_EXPAND_X = *SPRITES_EXPAND_Y = *SPRITES_MC = 0;
    char xpos = 24+15*8;
    for(char s:0..3) {
    	char s2 = s*2;
		SPRITES_XPOS[s2] = xpos;
		SPRITES_COLS[s] = BLACK;
		xpos = xpos+24;
    }
}

// The Y-position of the first sprite row
const char SPRITES_FIRST_YPOS = 49;
// The line of the first IRQ
const char IRQ_RASTER_FIRST = SPRITES_FIRST_YPOS + 19;
// The raster line of the next IRQ
volatile char irq_raster_next = IRQ_RASTER_FIRST;
// Y-pos of the sprites on the next IRQ
volatile char irq_sprite_ypos = SPRITES_FIRST_YPOS + 21;
// Index of the sprites to show on the next IRQ
volatile char irq_sprite_ptr = toSpritePtr(PLAYFIELD_SPRITES) + 3;
// Counting the 10 IRQs
volatile char irq_cnt = 0;

// Setup the IRQ
void sprites_irq_init() {
    asm { sei }
    // Acknowledge any IRQ and setup the next one
    *IRQ_STATUS = IRQ_RASTER;
    asm { lda CIA1_INTERRUPT }

    // Disable kernal & basic
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
    // Disable CIA 1 Timer IRQ
    *CIA1_INTERRUPT = CIA_INTERRUPT_CLEAR;
    // Set raster line
    *VIC_CONTROL &=0x7f;
    *RASTER = IRQ_RASTER_FIRST;
    // Enable Raster Interrupt
    *IRQ_ENABLE = IRQ_RASTER;
    // Set the IRQ routine
    *HARDWARE_IRQ = &sprites_irq;
    asm { cli }
}


// Raster Interrupt Routine - sets up the sprites covering the playfield
// Repeats 10 timers every 2 lines from line IRQ_RASTER_FIRST
// Utilizes duplicated gfx in the sprites to allow for some leeway in updating the sprite pointers
interrupt(hardware_clobber) void sprites_irq() {
    //(*BGCOL)++;
    // Clear decimal flag (because it is used by the score algorithm)
    asm { cld }
    // Place the sprites
    char ypos = irq_sprite_ypos;
	SPRITES_YPOS[0] = ypos;
	SPRITES_YPOS[2] = ypos;
	SPRITES_YPOS[4] = ypos;
	SPRITES_YPOS[6] = ypos;

	// Wait for the y-position before changing sprite pointers
	volatile char raster_sprite_gfx_modify = irq_raster_next+1;
	do {
	} while(*RASTER<raster_sprite_gfx_modify);

	char ptr = irq_sprite_ptr;
	if(render_screen_showing==0) {
	    PLAYFIELD_SPRITE_PTRS_1[0] = ptr++;
	    PLAYFIELD_SPRITE_PTRS_1[1] = ptr;
	    PLAYFIELD_SPRITE_PTRS_1[2] = ptr++;
	    PLAYFIELD_SPRITE_PTRS_1[3] = ptr;
	} else {
	    PLAYFIELD_SPRITE_PTRS_2[0] = ptr++;
	    PLAYFIELD_SPRITE_PTRS_2[1] = ptr;
	    PLAYFIELD_SPRITE_PTRS_2[2] = ptr++;
	    PLAYFIELD_SPRITE_PTRS_2[3] = ptr;
	}

    // Find next raster line / sprite positions
    ++irq_cnt;
    if(irq_cnt==9) {
    	irq_raster_next += 21;
    	irq_sprite_ypos = SPRITES_FIRST_YPOS;
    	irq_sprite_ptr = toSpritePtr(PLAYFIELD_SPRITES);
    } else if(irq_cnt==10) {
    	irq_cnt = 0;
    	irq_raster_next = IRQ_RASTER_FIRST;
    	irq_sprite_ypos += 21;
    	irq_sprite_ptr += 3;
    } else {
    	irq_raster_next += 20;
    	irq_sprite_ypos += 21;
    	irq_sprite_ptr += 3;
    }

    // Setup next interrupt
    *RASTER = irq_raster_next;

    // Acknowledge the IRQ and setup the next one
    *IRQ_STATUS = IRQ_RASTER;

    //(*BGCOL)--;
}
