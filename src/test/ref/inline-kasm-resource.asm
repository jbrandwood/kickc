// Example of inline kickasm resource data
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SPRITE = $c00
  .label SCREEN = $400
  .label SPRITES_ENABLE = $d015
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  // kickasm
main: {
    // *(SCREEN+$3f8) = (byte)((word)SPRITE/$40)
    lda #SPRITE/$40
    sta SCREEN+$3f8
    // *SPRITES_ENABLE = 1
    lda #1
    sta SPRITES_ENABLE
    // *SPRITES_XPOS = 100
    lda #$64
    sta SPRITES_XPOS
    // *SPRITES_YPOS = 100
    sta SPRITES_YPOS
    // }
    rts
}
.pc = SPRITE "SPRITE"
  .var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)

