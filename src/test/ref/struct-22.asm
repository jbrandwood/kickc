// Minimal struct with C-Standard behavior - call parameter (not supported yet)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label point1 = 2
    .label point2 = 4
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __0-1,y
    sta point1-1,y
    dey
    bne !-
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __1-1,y
    sta point2-1,y
    dey
    bne !-
    lda.z point1
    ldx point1+OFFSET_STRUCT_POINT_Y
    jsr print
    lda.z point2
    ldx point2+OFFSET_STRUCT_POINT_Y
    jsr print
    rts
}
// print(byte register(A) p_x, byte register(X) p_y)
print: {
    sta SCREEN
    stx SCREEN+1
    rts
}
  __0: .byte 2, 3
  __1: .byte 4, 5