// Attempt to store and use a sinus on zeropage
// $00/$11 is carefully chosen to be $ff - which plays well with the processor port

#include <c64.h>

// A 256-byte (co)sinus (with $ff in the first two entries)
const unsigned char align(0x100) SINTABLE[0x100] = kickasm {{
    .for(var i=0;i<$100;i++)
        .byte round(127.5+127.5*cos(toRadians(360*i/256)))
}};

// Storage for saving/restoring zeropage
const unsigned char align(0x100) ZP_STORAGE[0x100];

char* const SCREEN = 0x0400;

// A single sprite to animate
const align(0x40) char SPRITE[0x40] = kickasm {{ .fill $40,$ff }};

void main() {
    // Stop interrupts
    asm { sei }
    // Show sprite
    *SPRITES_ENABLE = 1;
    SPRITES_YPOS[0] = 100;
    SPRITES_XPOS[0] = 100;
    *(SCREEN+SPRITE_PTRS) = (byte)(SPRITE/0x40);

    saveZeropage();
    sinZeropage();
    animSprite();
    restoreZeropage();
}

// Save all values on zeropage
void saveZeropage() {
    asm {
        ldx #0
    !:
        lda $00,x
        sta ZP_STORAGE,x
        inx
        bne !-
    }
}

// Save all values on zeropage
void restoreZeropage() {
    asm {
        ldx #0
    !:
        lda ZP_STORAGE,x
        sta $00,x
        inx
        bne !-
    }
}

// Move the SINUS values to zeropage
void sinZeropage() {
    asm {
        ldx #0
    !:
        lda SINTABLE,x
        sta $00,x
        inx
        bne !-
    }
}

// Move a sprite in the sinus on zeropage
void animSprite() {
    kickasm {{
        ldx #$00
    repeat:
        lda #$fe
    !:
        cmp $d012
        bne !-
        lda #$ff
    !:
        cmp $d012
        bne !-
        .break
        lda $00,x
        clc
        adc #$38
        sta $d000
        lda #0
        adc #0
        sta $d010
        inx
        jmp repeat
    }}


}
