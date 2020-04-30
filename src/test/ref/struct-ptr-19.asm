// Demonstrates problem with passing struct pointer deref as parameter to call
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
  .label SCREEN = $400
main: {
    .label ptr = point
    .label point = 2
    // point = { 1, 2 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __0-1,y
    sta point-1,y
    dey
    bne !-
    // print(point)
    lda.z point
    ldy point+OFFSET_STRUCT_POINT_Y
    ldx #0
    jsr print
    // print(*ptr)
    lda.z ptr
    ldy ptr+OFFSET_STRUCT_POINT_Y
    jsr print
    // }
    rts
}
// print(byte register(A) p_x, byte register(Y) p_y)
print: {
    // SCREEN[idx++] = p.x
    sta SCREEN,x
    // SCREEN[idx++] = p.x;
    inx
    // SCREEN[idx++] = p.y
    tya
    sta SCREEN,x
    // SCREEN[idx++] = p.y;
    inx
    // }
    rts
}
  __0: .byte 1, 2
