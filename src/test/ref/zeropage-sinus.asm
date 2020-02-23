// Attempt to store and use a sinus on zeropage
// $00/$11 is carefully chosen to be $ff - which plays well with the processor port
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // The offset of the sprite pointers from the screen start address
  .const SPRITE_PTRS = $3f8
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label SPRITES_ENABLE = $d015
  .label SCREEN = $400
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
    // *(SCREEN+SPRITE_PTRS) = (byte)(SPRITE/0x40)
    lda #$ff&SPRITE/$40
    sta SCREEN+SPRITE_PTRS
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
// Move a sprite in the sinus on zeropage
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
// Move the SINUS values to zeropage
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
  // A 256-byte (co)sinus (with $ff in the first two entries)
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
