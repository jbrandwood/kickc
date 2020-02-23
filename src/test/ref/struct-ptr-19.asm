// Demonstrates problem with passing struct pointer deref as parameter to call
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
  .label idx = 2
main: {
    .label ptr = point
    .label point = 3
    // point = { 1, 2 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __0-1,y
    sta point-1,y
    dey
    bne !-
    // print(point)
    ldy.z point
    ldx point+OFFSET_STRUCT_POINT_Y
    lda #0
    sta.z idx
    jsr print
    // print(*ptr)
    ldy.z ptr
    ldx ptr+OFFSET_STRUCT_POINT_Y
    jsr print
    // }
    rts
}
// print(byte register(Y) p_x, byte register(X) p_y)
print: {
    // SCREEN[idx++] = p.x
    tya
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = p.x;
    iny
    // SCREEN[idx++] = p.y
    txa
    sta SCREEN,y
    // SCREEN[idx++] = p.y;
    iny
    sty.z idx
    // }
    rts
}
  __0: .byte 1, 2
