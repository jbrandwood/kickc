// Example program for the Commander X16
// Displays 32 64*64 TUT sprites

#pragma target(cx16) 
#include <cx16.h>
#include <6502.h>

#define NUM_SPRITES 32

// A 64*64 8bpp TUT sprite and palette
__align(0x1000) char SPRITE_PIXELS[64*64+0x200] = kickasm(resource "tut.png") {{
	.var pic = LoadPicture("tut.png")
    // palette: rgb->idx
    .var palette = Hashtable()
    // RGB value for each palette index
    .var palList = List()
    // Next palette index
    .var nxt_idx = 0;
    // Extract palette while outputting pixels as palete index values
    .for (var y=0; y<64; y++) {
    	.for (var x=0;x<64; x++) {
            // Find palette index (add if not known)
            .var rgb = pic.getPixel(x,y);
            .var idx = palette.get(rgb)
            .if(idx==null) {
                .eval idx = nxt_idx++;
                .eval palette.put(rgb,idx);
                .eval palList.add(rgb)
            }
            // Output pixel as palette index
            .byte idx
        }
    }
    .if(nxt_idx>256) .error "Image has too many colours "+nxt_idx
    // Output sprite palette (at offset 64*64 bytes)
    .for(var i=0;i<256;i++) {
        .var rgb = palList.get(i)
        .var red = floor(rgb / [256*256])
        .var green = floor(rgb/256) & 255
        .var blue = rgb & 255
        // bits 4-8: green, bits 0-3 blue
        .byte green&$f0  | blue/16
        // bits bits 0-3 red
        .byte red/16
    }
}};

// Address to use for sprite pixels in VRAM
const unsigned long SPRITE_PIXELS_VRAM = 0x08000; 

// Sprite attributes: 8bpp, in front, 64x64, address SPRITE_PIXELS_VRAM
struct VERA_SPRITE SPRITE_ATTR = { <(SPRITE_PIXELS_VRAM/32)|VERA_SPRITE_8BPP, 320-32, 240-32, 0x0c, 0xf0 };

void main() {
    // Copy sprite data to VRAM
    memcpy_to_vram((char)>SPRITE_PIXELS_VRAM, <SPRITE_PIXELS_VRAM, SPRITE_PIXELS, 64*64);
    // Copy sprite palette to VRAM
    memcpy_to_vram((char)>VERA_PALETTE, <VERA_PALETTE, SPRITE_PIXELS+64*64, 0x200);
    // Copy 8* sprite attributes to VRAM    
    char* vram_sprite_attr = <VERA_SPRITE_ATTR;
    for(char s=0;s<NUM_SPRITES;s++) {
        SPRITE_ATTR.X += 10;
        SPRITE_ATTR.Y += 10;
        memcpy_to_vram((char)>VERA_SPRITE_ATTR, vram_sprite_attr, &SPRITE_ATTR, sizeof(SPRITE_ATTR));
        vram_sprite_attr += sizeof(SPRITE_ATTR);
    }    
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
const char SINX_LEN = 241;
__align(0x100) unsigned int SINX[SINX_LEN] = kickasm {{
    .fillword 256, 288+288*sin(i*2*PI/SINX_LEN)
}};

// Y sine [0;480-64]
const char SINY_LEN = 251;
__align(0x100) unsigned int SINY[SINY_LEN] = kickasm {{
    .fillword 256, 208+208*sin(i*2*PI/SINY_LEN)
}};

// X sine index
volatile unsigned int sin_idx_x = 119;
// Y sine index
volatile unsigned int sin_idx_y = 79;

// VSYNC Interrupt Routine
__interrupt(rom_sys_cx16) void irq_vsync() {
    // Move the sprite around
    if(++sin_idx_x==SINX_LEN) sin_idx_x = 0;
    if(--sin_idx_y==0xffff) sin_idx_y = SINY_LEN-1;
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
        i_x += 25; if(i_x>=SINX_LEN) i_x -= SINX_LEN;
        i_y += 19; if(i_y>=SINY_LEN) i_y -= SINY_LEN;
    }

    // Reset the VSYNC interrupt
    *VERA_ISR = VERA_VSYNC;
    // Exit CX16 KERNAL IRQ
    asm {
        // soft exit (keep kernal running)
        jmp $e034 
    }
}    
