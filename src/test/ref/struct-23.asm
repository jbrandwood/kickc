// Minimal struct with C-Standard behavior - call return value (not supported yet)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label point1 = 2
    .label point2 = 4
    lda #3
    ldx #2
    jsr getPoint
    stx.z point1
    sta point1+OFFSET_STRUCT_POINT_Y
    txa
    sta SCREEN
    lda point1+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    lda #5
    ldx #4
    jsr getPoint
    stx.z point2
    sta point2+OFFSET_STRUCT_POINT_Y
    txa
    sta SCREEN+2
    lda point2+OFFSET_STRUCT_POINT_Y
    sta SCREEN+3
    rts
}
getPoint: {
    rts
}
