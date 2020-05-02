// Put a 2x2 font into sprites and show it on screen
#include <c64.h>
#include <multiplexer.h>

char * const CHARSET_DEFAULT = 0x1000;
char * const SPRITES = 0x3000;
char * const SCREEN =  0x0400;

// Address of sprite pointers on screen
char * const SCREEN_SPRITES = SCREEN + SPRITE_PTRS;

// Sprite pointer for sprite 0
char SPRITE_0 = toSpritePtr(SPRITES);

//char FONT[0x0800] = kickasm(resource "elefont.bin") {{
//	.import binary "elefont.bin"
//}};

char FONT[0x0800];

char align(0x100) YSIN[0x100] = kickasm {{
    .fill $100, round(142+89.5*sin(toRadians(360*i/256)))
}};

char align(0x100) XMOVEMENT[0x200] = kickasm {{
    //.lohifill $100, round(344-i*344/$100-86*sin(toRadians(360*i/$100)))
    //.lohifill $100, round(344-i*344/$100-129*sin(toRadians(360*i/$100)))
    .lohifill $100, round(344-i*344/$100 -86*sin(toRadians(360*i/$100)) -43*sin(toRadians(360*i/$80)))
    //.lohifill $100, round(344-i*344/$100-86*sin(toRadians(360*i/$80)))
}};

// The high-value table
char * const XMOVEMENT_HI = XMOVEMENT+0x100;

void main() {

    // Create 2x2 font from CHARGEN
    asm { sei }
    *PROCPORT = PROCPORT_RAM_CHARROM;
    font_2x2(CHARGEN, FONT);
    *PROCPORT = PROCPORT_BASIC_KERNEL_IO;
    asm { cli }

    // Convert font to sprites
    font_2x2_to_sprites(FONT, SPRITES, 64);

    // Initialize the multiplexer
    plexInit(SCREEN);

    // Show screen
    *D018 = toD018(SCREEN, CHARSET_DEFAULT);

    // Set the x-positions & pointers
    for(char s=0, x=0;s<PLEX_COUNT;s++,x+=8) {
        PLEX_PTR[s] = SPRITE_0+' ';
        PLEX_XPOS[s] = { XMOVEMENT_HI[x], XMOVEMENT[x] };
    }
    // Enable & initialize sprites
    *SPRITES_ENABLE = 0xff;
    for(char s: 0..7) {
        SPRITES_COLOR[s] = WHITE;
    }

    // Move the sprites
    plex_move();
    // Sort the sprites by y-position
    plexSort();

    // Enable the plex IRQ
    asm { sei }
    // Disable CIA 1 Timer IRQ
    CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR;
    // Set raster line to 0x00
    *VIC_CONTROL &=0x7f;
    *RASTER = 0x28;
    // Enable Raster Interrupt
    *IRQ_ENABLE = IRQ_RASTER;
    // Acknowledge any IRQ
    *IRQ_STATUS = IRQ_RASTER;
    // Set the IRQ routine
    *KERNEL_IRQ = &plex_irq;
    asm { cli }

    // Move & Sort - when needed!
    while(true) {
        while(!frame_done) {
        }
        frame_done = false;
        //*BORDER_COLOR = RED;
        // Move the sprites
        plex_move();
        // Sort the sprites by y-position
        plexSort();
        //*BORDER_COLOR = BLACK;
    }
}


// The scroll text
char SCROLL_TEXT[] = "camelot presents a spanking new contribution to the always hungry c64 scene. "
                     "in this time of the corona virus we have chosen to direct our efforts towards the safe haven of coding, pixeling and composing for our beloved old breadbin. "
                     "     ";

// The next char to use from the scroll text
char* scroll_text_next = SCROLL_TEXT;

// Y-sine index
char y_sin_idx = 0;
// X-movement index
char x_movement_idx = 0;

// Move the plex sprites in an Y-sine and scroll them to the left.
void plex_move() {
        char y_idx = y_sin_idx;
        char x_idx = x_movement_idx;
        for(char s: 0..PLEX_COUNT-1) {
            // Assign sine value
            PLEX_YPOS[s] = YSIN[y_idx];
            y_idx += 8;
            PLEX_XPOS[s] = { XMOVEMENT_HI[x_idx], XMOVEMENT[x_idx] };
            if(x_idx==0) {
                // Page boundary crossed - new scroll char! Detection is a bit flaky!
                // Restart scroll text of needed
                if(*scroll_text_next==0)
                    scroll_text_next = SCROLL_TEXT;
                // Read next char from the scroll text
                PLEX_PTR[s] = SPRITE_0+*scroll_text_next++;
             }
            x_idx +=8;
        }
        y_sin_idx += 3;
        x_movement_idx++;
}

// Signal used between IRQ and main loop. Set to true when the IRQ is done showing the sprites.
volatile bool frame_done = false;

// Show sprites from the multiplexer, rescheduling the IRQ as many times as needed
interrupt(kernel_min) void plex_irq() {
    asm { sei }
    //*BORDER_COLOR = WHITE;
    // Show sprites until finding one that should not be shown until a few raster lines later
    char rasterY;
    do {
        plexShowSprite();
        rasterY = plexFreeNextYpos();
    } while (plex_show_idx < PLEX_COUNT && rasterY < *RASTER+3);

    if (plex_show_idx<PLEX_COUNT) {
        // Set raster IRQ line to the next sprite Y-position
        *RASTER = rasterY;
    } else {
        // Reset the raster IRQ to the top of the screen
        *RASTER = 0x28;
        // Signal that the IRQ is done showing sprites
        frame_done = true;
    }
    // Acknowledge the IRQ
    *IRQ_STATUS = IRQ_RASTER;
    //*BORDER_COLOR = 0;
    asm { cli }
}

// Convert a 2x2-font to sprites
// - font_2x2 The source 2x2-font
// - sprites The destination sprites
// - num_chars The number of chars to convert
void font_2x2_to_sprites(char* font_2x2, char* sprites, char num_chars) {
    char * char_current = font_2x2;
    char * sprite = sprites;
    for(char c=0;c<num_chars;c++) {
        // Upper char
        char * char_left = char_current;
        char * char_right = char_current + 0x40*8;
        char sprite_idx = 0;
        for(char i: 0..20) {
            sprite[sprite_idx++] = char_left[i&7];
            sprite[sprite_idx++] = char_right[i&7];
            sprite[sprite_idx++] = 0x00;
            if(i==7) {
                // Lower char
                char_left = char_current + 0x80*8;
                char_right = char_current + 0xc0*8;
            } else if(i==15) {
                // Empty char
                char_left = font_2x2+' '*8;
                char_right = font_2x2+' '*8;
            }
        }
        char_current += 8;
        sprite += 0x40;
    }
}

// Create a 2x2-font by doubling all pixels of the 64 first chars
// The font layout is:
// - 0x00 - 0x3f Upper left glyphs
// - 0x40 - 0x7f Upper right glyphs
// - 0x80 - 0xbf Lower left glyphs
// - 0xc0 - 0xff Lower right glyphs
void font_2x2(char* font_original, char* font_2x2) {
    char* next_original = font_original;
    char* next_2x2 = font_2x2;
    for(char c: 0..0x3f) {
        char* next_2x2_left = next_2x2;
        char* next_2x2_right = next_2x2 + 0x40*8;
        char l2 = 0;
        for(char l: 0..7) {
            char glyph_bits = next_original[l];
            unsigned int glyph_bits_2x2 = 0;
            for(char b: 0..7) {
                // Find the bit
                char glyph_bit = (glyph_bits&0x80)?1uc:0uc;
                // Roll the bit into the current char twice
                glyph_bits_2x2 = glyph_bits_2x2<<1|glyph_bit;
                glyph_bits_2x2 = glyph_bits_2x2<<1|glyph_bit;
                // Move to next bit
                glyph_bits <<= 1;
            }
            // Put the generated 2x2-line into the 2x2-font twice
            next_2x2_left[l2] = >glyph_bits_2x2;
            next_2x2_left[l2+1] = >glyph_bits_2x2;
            next_2x2_right[l2] = <glyph_bits_2x2;
            next_2x2_right[l2+1] = <glyph_bits_2x2;
            l2 += 2;
            if(l2==8) {
                // Move to bottom chars
                next_2x2_left = next_2x2 + 0x80*8;
                next_2x2_right = next_2x2 + 0xc0*8;
                l2 = 0;
            }
        }
        next_2x2 += 8;
        next_original += 8;
    }
}
