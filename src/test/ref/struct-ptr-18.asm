// Demonstrates problem with passing struct array element as parameter to call
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
  .label idx = 2
main: {
    // points[0] = { 1, 2 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __0-1,y
    sta points-1,y
    dey
    bne !-
    // points[1] = { 3, 4 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __1-1,y
    sta points+1*SIZEOF_STRUCT_POINT-1,y
    dey
    bne !-
    lda #0
    sta.z idx
    tax
  __b1:
    // print(points[i])
    txa
    asl
    tay
    lda points,y
    sta.z print.p_x
    lda points+OFFSET_STRUCT_POINT_Y,y
    sta.z print.p_y
    jsr print
    // for ( char i: 0..1)
    inx
    cpx #2
    bne __b1
    // }
    rts
}
// print(byte zp(3) p_x, byte zp(4) p_y)
print: {
    .label p_x = 3
    .label p_y = 4
    // SCREEN[idx++] = p.x
    lda.z p_x
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = p.x;
    iny
    // SCREEN[idx++] = p.y
    lda.z p_y
    sta SCREEN,y
    // SCREEN[idx++] = p.y;
    iny
    sty.z idx
    // }
    rts
}
  points: .fill 2*2, 0
  __0: .byte 1, 2
  __1: .byte 3, 4
