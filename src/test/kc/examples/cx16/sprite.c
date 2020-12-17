// Example program for the Commander X16
// Displays some sprites - exceeding the per-line limits of the CX16

#pragma target(cx16) 
#include <cx16.h>
#include <6502.h>

// A 64*64 8bpp sprite 
align(0x100) char SPRITE_PIXELS[64*64] = kickasm(resource "sprite.png") {{
	.var pic = LoadPicture("sprite.png", List().add($000000, $ffffff))
	.for (var x=0;x<64; x++)
    	.for (var y=0; y<64; y++)
            .byte (pic.getPixel(x,y)==0) ? 0 : 1
}};

#define NUM_SPRITES 128

// Address to use for sprite pixels in VRAM
const unsigned long SPRITE_PIXELS_VRAM = 0x08000; 

// Sprite attributes: 8bpp, in front, 64x64, address SPRITE_PIXELS_VRAM
struct VERA_SPRITE SPRITE_ATTR = { <(SPRITE_PIXELS_VRAM/32)|VERA_SPRITE_8BPP, 320-32, 240-32, 0x0c, 0xf0 };

void main() {
    // Copy sprite data to VRAM
    memcpy_to_vram((char)>SPRITE_PIXELS_VRAM, <SPRITE_PIXELS_VRAM, SPRITE_PIXELS, sizeof(SPRITE_PIXELS));
    // Copy 8* sprite attributes to VRAM    
    char* vram_sprite_attr = <VERA_SPRITE_ATTR;
    for(char s=0;s<NUM_SPRITES;s++) {
        SPRITE_ATTR.X += 10;
        SPRITE_ATTR.Y += 10;
        memcpy_to_vram((char)>VERA_SPRITE_ATTR, vram_sprite_attr, &SPRITE_ATTR, sizeof(SPRITE_ATTR));
        vram_sprite_attr += sizeof(SPRITE_ATTR);
    }   
    // Make a border
    //*VERA_CTRL |= VERA_DCSEL;
    //*VERA_DC_HSTART = 16/4;
    //*VERA_DC_HSTOP = 624/4;
    //*VERA_DC_VSTART = 16/2;
    //*VERA_DC_VSTOP = 464/2;    
    // Enable sprites
    *VERA_CTRL &= ~VERA_DCSEL;
    *VERA_DC_VIDEO |= VERA_SPRITES_ENABLE;
    // Enable VSYNC IRQ (also set line bit 8 to 0)
    SEI();
    *KERNEL_IRQ = &irq_vsync;
    *VERA_IEN = VERA_VSYNC; 
    CLI();
}

// X sine [0;640-64]
align(0x100) unsigned int SINX[241] = kickasm {{
    .fillword 256, 288+288*sin(i*2*PI/241)
}};

// Y sine [0;480-64]
align(0x100) unsigned int SINY[251] = kickasm {{
    .fillword 256, 208+208*sin(i*2*PI/251)
}};

// X sine index
volatile unsigned int sin_idx_x = 119;
// Y sine index
volatile unsigned int sin_idx_y = 79;

// VSYNC Interrupt Routine
void irq_vsync() {
    // Color border
    //*VERA_CTRL &= ~VERA_DCSEL;
    //*VERA_DC_BORDER = 2; 
    // Move the sprite around
    if(++sin_idx_x==241) sin_idx_x = 0;
    if(--sin_idx_y==0xffff) sin_idx_y = 251-1;
    const char vram_sprite_attr_bank = (char)>VERA_SPRITE_ATTR;
    char *vram_sprite_pos = <VERA_SPRITE_ATTR+2;
    unsigned int i_x = sin_idx_x;
    unsigned int i_y = sin_idx_y;
    for(char s=0;s<NUM_SPRITES;s++) {
        SPRITE_ATTR.X = SINX[i_x];
        SPRITE_ATTR.Y = SINY[i_y];
        // Copy sprite positions to VRAM (the 4 relevant bytes in VERA_SPRITE_ATTR)
        memcpy_to_vram(vram_sprite_attr_bank, vram_sprite_pos, &SPRITE_ATTR+2, 4);
        vram_sprite_pos += sizeof(SPRITE_ATTR);
        i_x += 3; if(i_x>=241) i_x -= 241;
        i_y += 5; if(i_y>=251) i_y -= 251;
    }
    // Black border
    //*VERA_CTRL &= ~VERA_DCSEL;
    //*VERA_DC_BORDER = 0; 
    // Reset the VSYNC interrupt
    *VERA_ISR = VERA_VSYNC;
    // Exit CX16 KERNAL IRQ
    asm {
        // soft exit (keep kernal running)
        jmp $e034 
    }
}    
