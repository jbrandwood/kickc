// Minimal struct with C-Standard behavior - address-of
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label ptr = point1
    .label point1 = 2
    lda #2
    sta.z point1
    lda #3
    sta point1+OFFSET_STRUCT_POINT_Y
    lda.z ptr
    sta SCREEN
    lda ptr+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    rts
}
