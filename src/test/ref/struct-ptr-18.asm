// Demonstrates problem with passing struct array element as parameter to call
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
  .label SCREEN = $400
  .label idx = 2
main: {
    lda #1
    sta points
    lda #2
    sta points+OFFSET_STRUCT_POINT_Y
    lda #3
    sta points+1*SIZEOF_STRUCT_POINT
    lda #4
    sta points+OFFSET_STRUCT_POINT_Y+1*SIZEOF_STRUCT_POINT
    lda #0
    sta.z idx
    tax
  b1:
    txa
    asl
    tay
    lda points,y
    sta.z print.p_x
    lda points+OFFSET_STRUCT_POINT_Y,y
    sta.z print.p_y
    jsr print
    inx
    cpx #2
    bne b1
    rts
}
// print(byte zeropage(3) p_x, byte zeropage(4) p_y)
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
    sty.z idx
    rts
}
  points: .fill 2*2, 0
