.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const BLACK = 0
  .label BG_COLOR = $d021
main: {
    // *BG_COLOR = BLACK
    lda #BLACK
    sta BG_COLOR
    // }
    rts
}
