// Show the Happy New Year image as a MC bitmap
#include <c64.h>
#include <6502.h>
#include <string.h>
#include "byteboozer.h"

#pragma code_seg(CodePart1)
#pragma data_seg(DataPart1)

char * const P1_COLORS  = (char*)0xa800;   // A800-AFFF
char * const P1_PIXELS  = (char*)0xc000;   // C000-DFFF
char * const P1_SCREEN  = (char*)0xe000;   // E000-E3FF
char * const P1_SPRITES = (char*)0xfc00;   // E000-E3FF
char * const PIXELS_EMPTY = (char*)0xe800; // E800-EFFF
// A copy of the load screen and colors
char * const LOAD_SCREEN = (char*)0xe400;  // E400-E7FF
char * const LOAD_CHARSET = (char*)0xf000; // F000-F7FF
char * const LOAD_COLORS = (char*)0xf800;  // F800-FBFF

// Flipper cosine easing table
unsigned int * const FLIPPER_EASING = (unsigned int*)0xa400;

// Sprite pointers 
char * const P1_SCREEN_SPRITE_PTRS = (char*)0xe3f8; // P1_SCREEN+OFFSET_SPRITE_PTRS;

#pragma data_seg(InitPart1)

// MC Bitmap Data
char P1_PIXELS_CRUNCHED[] = kickasm(resource "happy-newyear.png", resource "mcbitmap.asm", uses P1_PIXELS) {{
    .modify B2() {
        .pc = P1_PIXELS "HAPPYNEWYEAR PIXELS"    
        #import "mcbitmap.asm"
        .var mcBmmData1 = getMcBitmapData(LoadPicture("happy-newyear.png"))
        .for (var y=0; y<25; y++)
            .for (var x=0; x<40; x++)
                .fill 8, getMcPixelData(x, y, i, mcBmmData1)
    }
}};

char P1_SCREEN_CRUNCHED[] = kickasm(uses P1_SCREEN) {{
    .modify B2() {
        .pc = P1_SCREEN "HAPPYNEWYEAR SCREEN"    
        .for (var y=0; y<25; y++)
            .for (var x=0; x<40; x++)
                .byte getMcScreenData(x, y, mcBmmData1)
    }
}};

char P1_COLORS_CRUNCHED[] = kickasm(uses P1_COLORS) {{
    .modify B2() {
        .pc = P1_COLORS "HAPPYNEWYEAR COLORS"    
        .for (var y=0; y<25; y++)
            .for (var x=0; x<40; x++)
                .byte getMcColorData(x, y, mcBmmData1)
    }
}};

// Sparkler sprites
char P1_SPRITES_CRUNCHED[] = kickasm(uses P1_SPRITES, resource "sparklers.png") {{
    .modify B2() {
        .pc = P1_SPRITES "P1_SPRITES"
        // Pixels                                                    11         01     10       11
        .var p1_sprites = LoadPicture("sparklers.png", List().add($000000, $daccc3, $472a24, $957a71))
        .for(var sx=0;sx<15;sx++) {
            .for (var y=0;y<21; y++) {
                .for (var c=0; c<3; c++) {
                    .byte p1_sprites.getMulticolorByte(sx*3+c,y)
                }
            }
            .byte 0
        }
    }
}};

// An easing curve from 0x000 to 0x130
__export char FLIPPER_EASING_CRUNCHED[] = kickasm {{
    .modify B2() {
        .pc = FLIPPER_EASING "FLIPPER_EASING"
        .fillword $130, round($98+$98*cos(PI+PI*i/$130))
    }
}};

#pragma data_seg(DataPart1)

void part1_init() {    
    // Disable IO
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_ALL;
    // Decrunch pixels
    byteboozer_decrunch(P1_PIXELS_CRUNCHED);
    // Enable IO, Disable kernal & basic
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
    // Decrunch screen
    byteboozer_decrunch(P1_SCREEN_CRUNCHED);
    // Decrunch colors
    byteboozer_decrunch(P1_COLORS_CRUNCHED);
    // Decrunch sprites
    byteboozer_decrunch(P1_SPRITES_CRUNCHED);
    // Decrunch flipper sine table
    byteboozer_decrunch(FLIPPER_EASING_CRUNCHED);
    // Initialize the badlines
    init_rasters();
    // Fill some empty pixels
    memset(PIXELS_EMPTY, 0x00, 0x800);
    // Enable CHARGEN, Disable kernal & basic
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_CHARROM;
    memcpy(LOAD_CHARSET, CHARGEN, 0x800);
    // Enable IO, Disable kernal & basic
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
    // Copy loading screen 
    memcpy(LOAD_SCREEN, DEFAULT_SCREEN, 0x0400);
    // Copy loading  colors
    memcpy(LOAD_COLORS, COLS, 1000);
}

void part1_run() {
    SEI();
    // Disable kernal & basic
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
    // Disable CIA 1 Timer IRQ
    CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR;
    // Acknowledge any timer IRQ
    asm { lda CIA1_INTERRUPT }
    // Acknowledge any VIC IRQ
    *IRQ_STATUS = 0x0f;
    // Set raster line to 0x136
    *VICII_CONTROL1 |= 0x80;
    *RASTER = IRQ_PART1_TOP_LINE;
    // Set the IRQ routine
    *HARDWARE_IRQ = &irq_part1_top;
    // Enable Raster Interrupt
    *IRQ_ENABLE = IRQ_RASTER;
    // Show Sparkler 
    VICII->SPRITES_MC = 0x01;
    VICII->SPRITE0_COLOR = PINK; 
    VICII->SPRITES_MCOLOR1 = YELLOW;
    VICII->SPRITES_MCOLOR2 = PURPLE;
    VICII->SPRITES_XMSB = 0x01; // 262
    VICII->SPRITE0_X = 22;      // 262
    VICII->SPRITE0_Y = 190;     // 144
    P1_SCREEN_SPRITE_PTRS[0] = toSpritePtr(P1_SPRITES);
    CLI();
    
    part1_loop();

}

// Signals the main() loop to do work when all rasters are complete
volatile char p1_work_ready = 0;

// Handle some stuff in the main() routine
void part1_loop() {
    p1_work_ready = 0;
    for(;;)  {
        while(p1_work_ready==0) ;
        // Fix colors
        flipper_fix_colors();
        // Show sparkler at 0:09
        if(!sparkler_active && demo_frame_count>9*50-3) {
            VICII->SPRITES_ENABLE = 0x01;
            sparkler_active = 1;
        }
        // Perform any demo-wide work
        demo_work();
        // Wait for the right place to exit part 1
        if(demo_frame_count>14*50) {   
            // Re-start the demo base IRQ
            demo_start();
            // Leave part 1
            break;
        }
        // My work is done!
        p1_work_ready = 0;
    }
}

// Top of the flipper
volatile unsigned int irq_flipper_top_line = 0x00;
// Bottom of the flipper
volatile unsigned int irq_flipper_bottom_line = 0x08;
// 1 if flipper is done
volatile char flipper_done = 0;

// 1 if the raster line is a badline
__align(0x100) char RASTER_BADLINES[0x130];

// Initialize the BADLINES
void init_rasters() {
    for(unsigned int i=0;i<sizeof(RASTER_BADLINES);i++) 
        RASTER_BADLINES[i] = 0;
    for(char b=0x32;b<0xfa;b+=8)
        RASTER_BADLINES[b] = 1;
}

const char IRQ_PART1_TOP_LINE = 0x36;

// IRQ running during set-up
__interrupt void irq_part1_top() {
    // Colors
    VICII->BORDER_COLOR = BLACK;
    VICII->BG_COLOR = BLACK;
    // Set BMM
    VICII->CONTROL1 |= VICII_BMM;
    // Set MCM
    VICII->CONTROL2 |= VICII_MCM;
    // Change graphics bank
    CIA2->PORT_A = toDd00(P1_SCREEN);
    // Show screen
    VICII->MEMORY = toD018(P1_SCREEN, P1_PIXELS);

    // Set up the flipper IRQ
    if(BYTE1(irq_flipper_top_line))
        *VICII_CONTROL1 |= 0x80;
    else
        *VICII_CONTROL1 &= 0x7f;
    *RASTER = BYTE0(irq_flipper_top_line)&0xf8;
    *HARDWARE_IRQ = &irq_flipper_top;
    // Signal main routine to play music    
    p1_work_ready = 1;
    // Acknowledge the IRQ
    *IRQ_STATUS = IRQ_RASTER;    
}

// IRQ running during set-up
// Flips from start screen to bitmap (stops the bitmap)
__interrupt void irq_flipper_top() {
    asm { nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop  }
    raster_fine(BYTE0(irq_flipper_top_line)&7);
    asm {
        lda #$9a            // VICII->MEMORY = toD018(LOAD_SCREEN, PIXELS_EMPTY);
        ldx #LIGHT_GREEN    // VICII->BORDER_COLOR = LIGHT_GREEN;
        ldy #$1b            // VICII->CONTROL1 &= ~VICII_BMM;
        sta VICII_MEMORY
        stx BORDER_COLOR
        sty VICII_CONTROL1
        stx BG_COLOR
        lda #$c8            // VICII->CONTROL2 &= ~VICII_MCM;
        sta VICII_CONTROL2
    }
    // Set up the flipper IRQ
    if(BYTE1(irq_flipper_bottom_line))
        *VICII_CONTROL1 |= 0x80;
    else
        *VICII_CONTROL1 &= 0x7f;
    *RASTER = BYTE0(irq_flipper_bottom_line)&0xf8;
    *HARDWARE_IRQ = &irq_flipper_bottom;
    // Acknowledge the IRQ
    *IRQ_STATUS = IRQ_RASTER;    
}

// Middle of the flipper
volatile unsigned int irq_flipper_idx = 0x00;

// IRQ running during set-up
// Flips from start screen to bitmap (starts the start-up screen)
__interrupt void irq_flipper_bottom() {
    asm { nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop nop  }
    raster_fine(BYTE0(irq_flipper_bottom_line)&7);
    // Colors
    asm { nop nop nop nop }
    VICII->BORDER_COLOR = LIGHT_BLUE;
    VICII->BG_COLOR = BLUE;
    // Show default screen
    VICII->MEMORY = toD018(LOAD_SCREEN, LOAD_CHARSET);

    if(!flipper_done) {        
        // Move the flipper down    
        unsigned int irq_flipper_line = FLIPPER_EASING[irq_flipper_idx++];
        // Check limits
        if(irq_flipper_line<8)
            irq_flipper_top_line = 0;
        else 
            irq_flipper_top_line = irq_flipper_line-8;

        if(irq_flipper_line>0x128)
            irq_flipper_bottom_line = 0x130;
        else 
            irq_flipper_bottom_line = irq_flipper_line+8;

        // Are we done
        if(irq_flipper_line==0x130)
            flipper_done = 1;
    }

    // Set up the IRQ again
    *VICII_CONTROL1 |=0x80;
    *RASTER = IRQ_PART1_TOP_LINE;
    *HARDWARE_IRQ = &irq_part1_top;
    // Acknowledge the IRQ
    *IRQ_STATUS = IRQ_RASTER;    
}

// Waits until at the exact start of raster line 
// Excepts to start at a line divisible by 8 (0x00, 0x08, x010, ...). 
// Waits line_offset (0-7) additional lines.
void raster_fine(char line_offset) {
    kickasm(uses line_offset, uses RASTER_BADLINES, clobbers "AXY") {{
        jmp aligned
        .align $100
    aligned:
        ldy RASTER
        ldx line_offset
        inx
    rst:
        nop 
        nop 
        nop 
        nop
        dex                             // 2
        beq done                        // 2
        lda RASTER_BADLINES,y           // 4
        beq notbad                      // 3
    bad:
        nop                             // 2
        nop 
        nop 
        nop 
        nop
        dex                             
        beq done                        
        iny                             
        nop                             
        bit $ea                         
    notbad:
        .fill 18, NOP
        bit $ea
        iny                             
        jmp rst                         
    done:
    }}
}

// The current char line where the flipper switches from bitmap to text
volatile char flipper_charline = 0;

// Fixes the colors for the flipper
// Updates with bitmap colors when the bitmap is being shown
void flipper_fix_colors() {
    if(irq_flipper_top_line>0x2e && irq_flipper_top_line<0xf6) {
        char charline = (char)((irq_flipper_top_line-0x2e)/8);
        if(charline>=flipper_charline) {
            unsigned int offset = (unsigned int)flipper_charline*40;
            // We have to update some colors
            char* colors = COLS+offset; 
            char* happy_cols = P1_COLORS+offset; 
            for(char i=0;i<40;i++)
                colors[i] = happy_cols[i];
            flipper_charline++;
        }
    }
}
