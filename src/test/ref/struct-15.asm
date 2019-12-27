// Minimal struct with C-Standard behavior - copying
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label point1 = 2
    .label point2 = 4
    lda #0
    sta.z point1
    sta point1+OFFSET_STRUCT_POINT_Y
    lda #2
    sta.z point1
    lda #3
    sta point1+OFFSET_STRUCT_POINT_Y
    lda.z point1
    sta.z point2
    lda point1+OFFSET_STRUCT_POINT_Y
    sta point2+OFFSET_STRUCT_POINT_Y
    lda.z point2
    sta SCREEN
    lda point2+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    rts
}
