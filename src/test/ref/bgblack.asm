.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d021
  .const BLACK = 0
main: {
    // *BGCOL = BLACK
    lda #BLACK
    sta BGCOL
    // }
    rts
}
