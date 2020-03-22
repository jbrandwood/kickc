// Test a struct array initialized with to few members (zero-filled for the rest)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_Y = 1
  .const SIZEOF_STRUCT_POINT = 3
  .label idx = 3
main: {
    .label i = 2
    lda #0
    sta.z idx
    sta.z i
  __b1:
    // print(points[i])
    lda.z i
    asl
    clc
    adc.z i
    tay
    ldx points,y
    lda points+OFFSET_STRUCT_POINT_Y,y
    sta.z print.p_y
    lda points+OFFSET_STRUCT_POINT_Y+1,y
    sta.z print.p_y+1
    jsr print
    // for ( char i: 0..3)
    inc.z i
    lda #4
    cmp.z i
    bne __b1
    // }
    rts
}
// print(byte register(X) p_x, signed word zp(4) p_y)
print: {
    .label p_y = 4
    // SCREEN[idx++] = p.x
    ldy.z idx
    txa
    sta SCREEN,y
    // SCREEN[idx++] = p.x;
    ldx.z idx
    inx
    // <p.y
    lda.z p_y
    // SCREEN[idx++] = <p.y
    sta SCREEN,x
    // SCREEN[idx++] = <p.y;
    inx
    // >p.y
    lda.z p_y+1
    // SCREEN[idx++] = >p.y
    sta SCREEN,x
    // SCREEN[idx++] = >p.y;
    inx
    // SCREEN[idx++] = ' '
    lda #' '
    sta SCREEN,x
    // SCREEN[idx++] = ' ';
    inx
    stx.z idx
    // }
    rts
}
  points: .byte 1
  .word $83f
  .byte 3
  .word $107e
  .fill SIZEOF_STRUCT_POINT, 0
  .fill SIZEOF_STRUCT_POINT, 0
