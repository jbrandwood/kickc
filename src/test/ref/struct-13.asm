// Minimal struct with C-Standard behavior - declaration, instantiation and usage
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_Y = 1
  .label point = 2
__bbegin:
  lda #0
  sta.z point
  sta point+OFFSET_STRUCT_POINT_Y
  jsr main
  rts
main: {
    lda #2
    sta.z point
    lda #3
    sta point+OFFSET_STRUCT_POINT_Y
    lda.z point
    sta SCREEN
    lda point+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    rts
}
