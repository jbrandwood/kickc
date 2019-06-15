// Minimal struct - modifying pointer to struct in memory using arrow operator
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINT_Y = 1
  .label points = $1000
main: {
    .label SCREEN = $400
    lda #5
    clc
    adc points
    sta points
    lda #5
    clc
    adc points+OFFSET_STRUCT_POINT_Y
    sta points+OFFSET_STRUCT_POINT_Y
    lda points
    sta SCREEN
    lda points+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    rts
}
