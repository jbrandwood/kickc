// Example showing how to crunch and decrunch part of a file using the KickAss Cruncher Plugins
// Exomizer Example
// https://github.com/p-a/kickass-cruncher-plugins

#pragma target(c64)
#pragma link("crunching.ld")
#include <c64.h>

// Address to decrunch the sprite to
char * const SPRITE = (char*)0x2000;

char * const SPRITES_PTR = DEFAULT_SCREEN+OFFSET_SPRITE_PTRS;

void main() {
    // Decrunch sprite file into memory
    kickasm {{
        :EXO_DECRUNCH(CRUNCHED_SPRITE_END)
    }}
    // Show the loaded sprite on screen
    VICII->SPRITES_ENABLE = %00000001;
    SPRITES_PTR[0] = toSpritePtr(SPRITE);
    SPRITES_COLOR[0] = GREEN;
    SPRITES_XPOS[0] = 0x15;
    SPRITES_YPOS[0] = 0x33;
}

// The exomizer decruncher
__export char EXOMIZER[] = kickasm(resource "exomizer_decrunch.asm") {{
    .const EXO_LITERAL_SEQUENCES_USED = true
    .const EXO_ZP_BASE = $02
    .const EXO_DECRUNCH_TABLE = $0200
    #import "exomizer_decrunch.asm"
}};

// Array with crunched data created using inline kickasm
__export char CRUNCHED_SPRITE[] = kickasm(uses SPRITE, resource "sprite.png") {{
    .modify MemExomizer(false, true) {
	    .pc = SPRITE
        .var pic = LoadPicture("sprite.png", List().add($000000, $ffffff))
        .for (var y=0; y<21; y++)
            .for (var x=0;x<3; x++)
                .byte pic.getSinglecolorByte(x,y)
    }
    CRUNCHED_SPRITE_END:
}};

