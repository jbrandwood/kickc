// Attempt to store and use a sine on zeropage
// $00/$11 is carefully chosen to be $ff - which plays well with the processor port
  // Commodore 64 PRG executable file
.file [name="zeropage-sinus.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  /// The offset of the sprite pointers from the screen start address
  .const OFFSET_SPRITE_PTRS = $3f8
  /// Sprite X position register for sprite #0
  .label SPRITES_XPOS = $d000
  /// Sprite Y position register for sprite #0
  .label SPRITES_YPOS = $d001
  /// Sprite enable register
  .label SPRITES_ENABLE = $d015
  .label SCREEN = $400
.segment Code
main: {
    // asm
    // Stop interrupts
    sei
    // *SPRITES_ENABLE = 1
    // Show sprite
    lda #1
    sta SPRITES_ENABLE
    // SPRITES_YPOS[0] = 100
    lda #$64
    sta SPRITES_YPOS
    // SPRITES_XPOS[0] = 100
    sta SPRITES_XPOS
    // *(SCREEN+OFFSET_SPRITE_PTRS) = (byte)(SPRITE/0x40)
    lda #$ff&SPRITE/$40
    sta SCREEN+OFFSET_SPRITE_PTRS
    // saveZeropage()
    jsr saveZeropage
    // sinZeropage()
    jsr sinZeropage
    // animSprite()
    jsr animSprite
    // restoreZeropage()
    jsr restoreZeropage
    // }
    rts
}
// Save all values on zeropage
saveZeropage: {
    // asm
    ldx #0
  !:
    lda.z 0,x
    sta ZP_STORAGE,x
    inx
    bne !-
    // }
    rts
}
// Move the SINE values to zeropage
sinZeropage: {
    // asm
    ldx #0
  !:
    lda SINTABLE,x
    sta.z 0,x
    inx
    bne !-
    // }
    rts
}
// Move a sprite in the sine on zeropage
animSprite: {
    // kickasm
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
    
    // }
    rts
}
// Save all values on zeropage
restoreZeropage: {
    // asm
    ldx #0
  !:
    lda ZP_STORAGE,x
    sta.z 0,x
    inx
    bne !-
    // }
    rts
}
.segment Data
  // A 256-byte (co)sine (with $ff in the first two entries)
  .align $100
SINTABLE:
.for(var i=0;i<$100;i++)
        .byte round(127.5+127.5*cos(toRadians(360*i/256)))

  // Storage for saving/restoring zeropage
  .align $100
  ZP_STORAGE: .fill $100, 0
  // A single sprite to animate
  .align $40
SPRITE:
.fill $40,$ff 
