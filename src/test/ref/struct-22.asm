// Minimal struct with C-Standard behavior - call parameter (not supported yet)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
  .label SCREEN = $400
main: {
    .label point1 = 2
    .label point2 = 4
    // point1 = { 2, 3 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __0-1,y
    sta point1-1,y
    dey
    bne !-
    // point2 = { 4, 5 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __1-1,y
    sta point2-1,y
    dey
    bne !-
    // print(point1)
    ldx.z point1
    lda point1+OFFSET_STRUCT_POINT_Y
    jsr print
    // print(point2)
    ldx.z point2
    lda point2+OFFSET_STRUCT_POINT_Y
    jsr print
    // }
    rts
}
// print(byte register(X) p_x, byte register(A) p_y)
print: {
    // SCREEN[0] = p.x
    stx SCREEN
    // SCREEN[1] = p.y
    sta SCREEN+1
    // }
    rts
}
  __0: .byte 2, 3
  __1: .byte 4, 5
