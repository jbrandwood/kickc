// Demonstrates initializing an array of structs
// Array of structs containing words
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    .label _4 = 3
    .label idx = 2
    lda #0
    sta idx
    tax
  b1:
    txa
    asl
    stx $ff
    clc
    adc $ff
    sta _4
    tay
    lda points,y
    ldy idx
    sta SCREEN,y
    inc idx
    ldy _4
    lda points+OFFSET_STRUCT_POINT_Y,y
    ldy idx
    sta SCREEN,y
    inc idx
    ldy _4
    lda points+OFFSET_STRUCT_POINT_Y+1,y
    ldy idx
    sta SCREEN,y
    inc idx
    inx
    cpx #3
    bne b1
    rts
}
points:
  .byte 1
  .word 2
  .byte 3
  .word 4
  .byte 5
  .word 6
