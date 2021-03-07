// Commander X16 Load a file to a memory bank

#pragma target(cx16)
#pragma link("cx16-bankload.ld")

#include <cx16.h>
#include <cx16-kernal.h>
#include <cx16-veralib.h>
#include <cx16-kernal.h>
#include <6502.h>
#include <conio.h>
#include <printf.h>
#include <stdio.h>

#pragma data_seg(Sprite)
export char SPRITE_PIXELS[] = kickasm(resource "ship.png") {{
    .var pic = LoadPicture("ship.png")
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
}};

#pragma data_seg(Data)

void main() {

    vera_layer_set_text_color_mode( 1, VERA_LAYER_CONFIG_16C );
    screenlayer(1);
    clrscr();
    printf("\n\nsprite banked file load and display demo.\n");

    // RAM Bank where sprite is loaded
    const dword BANK_SPRITE = 0x12000;
    // VRAM address of sprite
    const dword VRAM_SPRITE = 0x10000;
    // Sprite attributes: 8bpp, in front, 64x64, address SPRITE_PIXELS_VRAM
    struct VERA_SPRITE SPRITE_ATTR = { <(VRAM_SPRITE/32)|VERA_SPRITE_8BPP, 320-32, 240-32, 0x0c, 0xf1 };

    char status = load_to_bank(8, "SPRITE", BANK_SPRITE );

    memcpy_bank_to_vram(VERA_PALETTE+32, BANK_SPRITE-2, 32);
    memcpy_bank_to_vram(VRAM_SPRITE, BANK_SPRITE+32-2, 64*32);

    SPRITE_ATTR.ADDR = <(VRAM_SPRITE/32)|VERA_SPRITE_4BPP;
    SPRITE_ATTR.X = 100;
    SPRITE_ATTR.Y = 100;
    memcpy_to_vram((char)>VERA_SPRITE_ATTR, <VERA_SPRITE_ATTR, &SPRITE_ATTR, sizeof(SPRITE_ATTR));

    // Enable sprites
    *VERA_CTRL &= ~VERA_DCSEL;
    *VERA_DC_VIDEO |= VERA_SPRITES_ENABLE;

}
