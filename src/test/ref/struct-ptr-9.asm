// Minimal struct -  array access with struct value copying (and initializing)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    ldy #0
  b1:
    tya
    asl
    tax
    lda #2
    sta points,x
    tya
    sta points+OFFSET_STRUCT_POINT_Y,x
    iny
    cpy #2
    bne b1
    ldx #0
  b2:
    txa
    asl
    tay
    lda points,y
    sta SCREEN,y
    lda points+OFFSET_STRUCT_POINT_Y,y
    sta SCREEN+OFFSET_STRUCT_POINT_Y,y
    inx
    cpx #2
    bne b2
    rts
}
  points: .fill 2*2, 0
