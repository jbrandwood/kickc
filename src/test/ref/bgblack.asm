.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d021
  // The colors of the C64
  .const BLACK = 0
main: {
    lda #BLACK
    sta BGCOL
    rts
}
