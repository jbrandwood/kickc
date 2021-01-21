// Tests Krill Loader
// Load a file to memory using the Krill loader
// The krillload.ld link file creates a D64 disk image containing the executable and the sprite.
// To execute the program succesfully you must mount the D64 disk image and execute the krillload.PRG program
#pragma link("krillload.ld")
#pragma extension("d64")

// Encoding needed for filename
#pragma encoding(petscii_mixed)

#include "krill.c"
#include <c64.h>

// Sprite file
#pragma data_seg(Sprite)
// The sprite data
export __address(0x2040) char SPRITE[0x40] = kickasm(resource "sprite.png") {{
    .var pic = LoadPicture("sprite.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)
}};

// Program file
#pragma data_seg(Data)

char* const SCREEN = 0x0400;
char* const SPRITES_PTR = SCREEN+OFFSET_SPRITE_PTRS;

void main() {
    // Install the Krill drive code
    char status = krill_install();
    if(status!=KRILL_OK) {
        VICII->BORDER_COLOR = 0x02;
        return;
    }
    // Load sprite file from disk
    status = krill_loadraw("sprite");
    if(status!=KRILL_OK) {
        VICII->BORDER_COLOR = 0x02;
        return;
    }
    // Show the loaded sprite on screen
    VICII->SPRITES_ENABLE = %00000001;
    SPRITES_PTR[0] = toSpritePtr(SPRITE);
    SPRITES_COLOR[0] = GREEN;
    SPRITES_XPOS[0] = 0x15;
    SPRITES_YPOS[0] = 0x33;
}
