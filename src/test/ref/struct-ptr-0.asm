// Minimal struct - array of struct
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    .label __5 = 2
    ldx #0
  __b1:
    txa
    asl
    sta.z __5
    tay
    txa
    sta points,y
    txa
    tay
    iny
    tya
    ldy.z __5
    sta points+OFFSET_STRUCT_POINT_Y,y
    inx
    cpx #5
    bne __b1
    ldy #0
  __b2:
    tya
    asl
    tax
    lda points,x
    sta SCREEN,y
    lda points+OFFSET_STRUCT_POINT_Y,x
    sta SCREEN+$28,y
    iny
    cpy #5
    bne __b2
    rts
}
  points: .fill 2*4, 0
