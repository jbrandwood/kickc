.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const BLACK = 0
  .label BGCOL = $d021
main: {
    // *BGCOL = BLACK
    lda #BLACK
    sta BGCOL
    // }
    rts
}
