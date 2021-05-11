// Example program for the Commander X16

#pragma target(cx16)
#pragma link("spacedemo.ld")

#pragma data_seg(Data)

#include <cx16.h>
#include <cx16-kernal.h>
#include <cx16-veralib.h>
#include <6502.h>
#include <peekpoke.h>
#include <conio.h>
#include <printf.h>
#include <stdio.h>

const byte NUM_SPRITES = 12;
const byte NUM_TILES_SMALL = 4;
const byte NUM_TILES_LARGE = 4;

#pragma data_seg(Palettes)
export char* PALETTES;

#pragma data_seg(Sprites)
export char SPRITE_PIXELS[] = kickasm(resource "Ship_1/ship_1_360_1.png") {{
    .var pic = LoadPicture("Ship_1/ship_1_360_1.png")
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
        }
    }
    .if(nxt_idx>16) .error "Image has too many colours "+nxt_idx
    
    .segment Palettes    
    .for(var i=0;i<16;i++) {
        .var rgb = palList.get(i)
        .var red = floor(rgb / [256*256])
        .var green = floor(rgb/256) & 255
        .var blue = rgb & 255
        // bits 4-8: green, bits 0-3 blue
        .byte green&$f0  | blue/16
        // bits bits 0-3 red
        .byte red/16
    }

    .segment Sprites
    .for(var p=1;p<=NUM_SPRITES;p++) {
        .var pic = LoadPicture("Ship_1/ship_1_360_" + p + ".png")
        .for (var y=0; y<64; y++) {
            .for (var x=0;x<64; x+=2) {
                // Find palette index (add if not known)
                .var rgb = pic.getPixel(x,y);
                .var idx1 = palette.get(rgb)
                .if(idx1==null) {
                    .printnow "unknown rgb value!"
                }
                // Find palette index (add if not known)
                .eval rgb = pic.getPixel(x+1,y);
                .var idx2 = palette.get(rgb)
                .if(idx2==null) {
                    .printnow "unknown rgb value!"
                }
                .byte idx1*16+idx2;
            }
        }
    }
}};

#pragma data_seg(TileS)
export char TILE_PIXELS_SMALL[] = kickasm(resource "Metal_1/frame_1.png") {{
    // palette: rgb->idx
    .var palette2 = Hashtable()
    // RGB value for each palette index
    .var palList2 = List()
    // Next palette index
    // Extract palette while outputting pixels as palete index values
    .var nxt_idx2 = 0;
    .for(var p=1;p<=NUM_TILES_SMALL;p++) {
        .var pic = LoadPicture("Metal_1/frame_" + p + ".png")
        .for (var y=0; y<32; y++) {
            .for (var x=0;x<32; x++) {
                // Find palette index (add if not known)
                .var rgb = pic.getPixel(x,y);
                .var idx = palette2.get(rgb)
                .if(idx==null) {
                    .eval idx = nxt_idx2++;
                    .eval palette2.put(rgb,idx);
                    .eval palList2.add(rgb)
                }
            }
        }
    }
    .if(nxt_idx2>16) .error "Image has too many colours "+nxt_idx2
    
    .segment Palettes    
    .for(var i=0;i<16;i++) {
        .var rgb = 16*256*256+16*256+16
        .if(i<palList2.size())
            .eval rgb = palList2.get(i)
        .var red = floor(rgb / [256*256])
        .var green = floor(rgb/256) & 255
        .var blue = rgb & 255
        // bits 4-8: green, bits 0-3 blue
        .byte green&$f0  | blue/16
        // bits bits 0-3 red
        .byte red/16
        .printnow "tile small: rgb = " + rgb + ", i = " + i
    }

    .segment TileS
    .var count = 0
    .for(var p=1;p<=NUM_TILES_SMALL;p++) {
        .var pic = LoadPicture("Metal_1/frame_" + p + ".png")
        .for(var j=0; j<32; j+=16) {
            .for(var i=0; i<32; i+=16) {
                .for (var y=j; y<j+16; y++) {
                    .for (var x=i; x<i+16; x+=2) {
                        // .printnow "j="+j+",y="+y+",i="+i+",x="+x
                        // Find palette index (add if not known)
                        .var rgb = pic.getPixel(x,y);
                        .var idx1 = palette2.get(rgb)
                        .if(idx1==null) {
                            .error "unknown rgb value!"
                        }
                        // Find palette index (add if not known)
                        .eval rgb = pic.getPixel(x+1,y);
                        .var idx2 = palette2.get(rgb)
                        .if(idx2==null) {
                            .error "unknown rgb value!"
                        }
                        .byte idx1*16+idx2;
                        .eval count++;
                    }
                }
            }
        }
    }
    .printnow "small count = " + count
}};

#pragma data_seg(TileB)
export char TILE_PIXELS_LARGE[] = kickasm(resource "Metal_1/metal_1.png") {{
    .var pic3 = LoadPicture("Metal_1/metal_1.png")
    // palette: rgb->idx
    .var palette3 = Hashtable()
    // RGB value for each palette index
    .var palList3 = List()
    // Next palette index
    .var nxt_idx3 = 0;
    // Extract palette while outputting pixels as palete index values
    .for (var y=0; y<64; y++) {
        .for (var x=0;x<64; x++) {
            // Find palette index (add if not known)
            .var rgb = pic3.getPixel(x,y);
            .var idx = palette3.get(rgb)
            .if(idx==null) {
                .eval idx = nxt_idx3++;
                .eval palette3.put(rgb,idx);
                .eval palList3.add(rgb)
            }
        }
    }
    .if(nxt_idx3>16) .error "Image has too many colours "+nxt_idx3

    .segment Palettes    
    .for(var i=0;i<16;i++) {
        .var rgb = 0
        .if(i<palList3.size())
            .eval rgb = palList3.get(i)
        .var red = floor(rgb / [256*256])
        .var green = floor(rgb/256) & 255
        .var blue = rgb & 255
        // bits 4-8: green, bits 0-3 blue
        .byte green&$f0  | blue/16
        // bits bits 0-3 red
        .byte red/16
        // .printnow "tile large: rgb = " + rgb + ", i = " + i
    }

    .segment TileB
    .eval count = 0
    .for(var p=1;p<=NUM_TILES_LARGE;p++) {
        .var pic = LoadPicture("Metal_1/metal_" + p + ".png")
        .for(var j=0; j<64; j+=16) {
            .for(var i=0; i<64; i+=16) {
                .for (var y=j; y<j+16; y++) {
                    .for (var x=i; x<i+16; x+=2) {
                        // Find palette index (add if not known)
                        .var rgb = pic.getPixel(x,y);
                        .var idx1 = palette3.get(rgb)
                        .if(idx1==null) {
                            .error "unknown rgb value!"
                        }
                        // Find palette index (add if not known)
                        .eval rgb = pic.getPixel(x+1,y);
                        .var idx2 = palette3.get(rgb)
                        .if(idx2==null) {
                            .error "unknown rgb value!"
                        }
                        .byte idx1*16+idx2;
                        .eval count++;
                    }
                }
            }
        }
    }
    .printnow "count = " + count
}};


#pragma data_seg(Data)

word sprites[NUM_SPRITES];

// Addressed used for graphics in main banked memory.
const dword BANK_SPRITES = 0x02000;
const dword BANK_TILES_SMALL = 0x14000;
const dword BANK_TILES_LARGE = 0x16000;
const dword BANK_PALETTE = 0x18000;

// Addresses used to store graphics in VERA VRAM.
const dword VRAM_SPRITES = 0x00000; 
const dword VRAM_TILES_SMALL = 0x14000; 
const dword VRAM_TILES_LARGE = 0x14800; 
const dword VRAM_PALETTE = 0x18000;

word sprite_offset = <(VRAM_SPRITES/32)|VERA_SPRITE_4BPP;
// Sprite attributes: 8bpp, in front, 64x64, address SPRITE_PIXELS_VRAM
struct VERA_SPRITE SPRITE_ATTR = { <(VRAM_SPRITES/32)|VERA_SPRITE_8BPP, 320-32, 240-32, 0x0c, 0xf1 };

void main() {

    memcpy_in_vram(1, 0xF000, VERA_INC_1, 0, 0xF800, VERA_INC_1, 256*8); // We copy the 128 character set of 8 bytes each.
    vera_layer_mode_tile(1, (dword)0x1A000, (dword)0x1F000, 128, 64, 8, 8, 1);
    screenlayer(1);
    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    // Loading the graphics in main banked memory.
    char status = load_to_bank(8, "SPRITES", BANK_SPRITES);
    status = load_to_bank(8, "TILES", BANK_TILES_SMALL);
    status = load_to_bank(8, "TILEB", BANK_TILES_LARGE);
    
    // Load the palette in main banked memory.
    status = load_to_bank(8, "PALETTES", BANK_PALETTE);

    // Copy graphics to the VERA VRAM.
    memcpy_bank_to_vram(VRAM_SPRITES, BANK_SPRITES-2, (dword)64*64*NUM_SPRITES/2);
    memcpy_bank_to_vram(VRAM_TILES_SMALL, BANK_TILES_SMALL-2, (dword)32*32*(NUM_TILES_SMALL)/2);
    memcpy_bank_to_vram(VRAM_TILES_LARGE, BANK_TILES_LARGE-2, (dword)64*64*(NUM_TILES_LARGE)/2);

    // Load the palette in VERA palette registers, but keep the first 16 colors untouched.
    memcpy_bank_to_vram(VERA_PALETTE+32, BANK_PALETTE-2, (dword)32*3);

    // Now we activate the tile mode.
    vera_layer_mode_tile(0, (dword)0x10000, VRAM_TILES_SMALL, 128, 64, 16, 16, 4);

    POKE(0x9f61, 0); // let's put back bank 0.
    vera_vram_address0(0x10000,VERA_INC_1);
    for(byte r=0;r<42;r+=12) {
        for(byte j=0;j<16;j+=8) {
            for(byte i=0;i<4;i+=2) {
                for(byte c=0;c<128;c+=4) {
                    *VERA_DATA0 = 0+i+j;
                    *VERA_DATA0 = 0x20;
                    *VERA_DATA0 = 1+i+j;
                    *VERA_DATA0 = 0x20;
                    *VERA_DATA0 = 4+i+j;
                    *VERA_DATA0 = 0x20;
                    *VERA_DATA0 = 5+i+j;
                    *VERA_DATA0 = 0x20;
                }
            }
        }
        for(byte j=0;j<64;j+=32) {
            for(byte i=0;i<16;i+=4) {
                for(byte c=0;c<128;c+=8) {
                    *VERA_DATA0 = 16+i+j;
                    *VERA_DATA0 = 0x30;
                    *VERA_DATA0 = 17+i+j;
                    *VERA_DATA0 = 0x30;
                    *VERA_DATA0 = 18+i+j;
                    *VERA_DATA0 = 0x30;
                    *VERA_DATA0 = 19+i+j;
                    *VERA_DATA0 = 0x30;
                    *VERA_DATA0 = 32+i+j;
                    *VERA_DATA0 = 0x30;
                    *VERA_DATA0 = 33+i+j;
                    *VERA_DATA0 = 0x30;
                    *VERA_DATA0 = 34+i+j;
                    *VERA_DATA0 = 0x30;
                    *VERA_DATA0 = 35+i+j;
                    *VERA_DATA0 = 0x30;
                }
            }
        }
    }
    vera_layer_show(0);


    // Copy sprite palette to VRAM
    // Copy 8* sprite attributes to VRAM    
    char* vram_sprite_attr = (char*)<VERA_SPRITE_ATTR;
    for(char s=0;s<NUM_SPRITES;s++) {
        sprites[s] = sprite_offset;
        SPRITE_ATTR.ADDR = sprite_offset;
        SPRITE_ATTR.X += 68;
        SPRITE_ATTR.Y = 100;
        memcpy_to_vram((char)>VERA_SPRITE_ATTR, vram_sprite_attr, &SPRITE_ATTR, sizeof(SPRITE_ATTR));
        vram_sprite_attr += sizeof(SPRITE_ATTR);
        sprite_offset += 64;
    }    
    // Enable sprites
    *VERA_CTRL &= ~VERA_DCSEL;
    *VERA_DC_VIDEO |= VERA_SPRITES_ENABLE;
    // Enable VSYNC IRQ (also set line bit 8 to 0)
    SEI();
    *KERNEL_IRQ = &irq_vsync;
    *VERA_IEN = VERA_VSYNC; 
    CLI();

    while(!getin());
}

volatile byte i = 0;
volatile byte a = 4;
volatile word vscroll = 0;
volatile word scroll_action = 2;

// VSYNC Interrupt Routine
__interrupt(rom_sys_cx16) void irq_vsync() {
    // Move the sprite around

    a--;
    if(a==0) {
        a=4;
        const char vram_sprite_attr_bank = (char)>VERA_SPRITE_ATTR;
        char *vram_sprite_attr = (char*)<VERA_SPRITE_ATTR;
        unsigned int i_x = 0;
        unsigned int i_y = 0;
        for(word s=0;s<NUM_SPRITES;s++) {
            word x = s+i;
            if(x>=NUM_SPRITES) {
                x-=NUM_SPRITES;
            }
            SPRITE_ATTR.ADDR = sprites[x];
            SPRITE_ATTR.X = (word)40+((word)(s&03)<<7);
            SPRITE_ATTR.Y = (word)100+((word)(s>>2)<<7);
            // Copy sprite positions to VRAM (the 4 relevant bytes in VERA_SPRITE_ATTR)
            memcpy_to_vram(vram_sprite_attr_bank, vram_sprite_attr, &SPRITE_ATTR, 6);
            vram_sprite_attr += sizeof(SPRITE_ATTR);
        }

        i++;
        if(i>=NUM_SPRITES) i=0;

    }

    if(scroll_action--) {
        scroll_action = 2;
        vscroll++;
        if(vscroll>(32+64)*2-1) vscroll=0;
        vera_layer_set_vertical_scroll(0,vscroll);
    }

    // Reset the VSYNC interrupt
    *VERA_ISR = VERA_VSYNC;
}
