// Minimal struct with C-Standard behavior - declaration, instantiation and usage
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    lda #2
    sta points
    lda #3
    sta points+OFFSET_STRUCT_POINT_Y
    lda points
    sta SCREEN
    lda points+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    rts
}
  points: .fill 2*1, 0
