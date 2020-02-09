// Test a struct array initialized with to few members (zero-filled for the rest)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_Y = 1
  .const SIZEOF_STRUCT_POINT = 3
  .label idx = 2
main: {
    lda #0
    sta.z idx
    tax
  __b1:
    txa
    asl
    stx.z $ff
    clc
    adc.z $ff
    tay
    lda points,y
    sta.z print.p_x
    lda points+OFFSET_STRUCT_POINT_Y,y
    sta.z print.p_y
    lda points+OFFSET_STRUCT_POINT_Y+1,y
    sta.z print.p_y+1
    jsr print
    inx
    cpx #4
    bne __b1
    rts
}
// print(byte zp(3) p_x, signed word zp(4) p_y)
print: {
    .label p_x = 3
    .label p_y = 4
    lda.z p_x
    ldy.z idx
    sta SCREEN,y
    iny
    lda.z p_y
    sta SCREEN,y
    iny
    lda.z p_y+1
    sta SCREEN,y
    iny
    lda #' '
    sta SCREEN,y
    iny
    sty.z idx
    rts
}
  points: .byte 1
  .word $83f
  .byte 3
  .word $107e
  .fill SIZEOF_STRUCT_POINT, 0
  .fill SIZEOF_STRUCT_POINT, 0
