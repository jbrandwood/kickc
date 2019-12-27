// Minimal struct with C-Standard behavior - call parameter (not supported yet)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label point1 = 2
    .label point2 = 4
    lda #2
    sta.z point1
    lda #3
    sta point1+OFFSET_STRUCT_POINT_Y
    lda #4
    sta.z point2
    lda #5
    sta point2+OFFSET_STRUCT_POINT_Y
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
