.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const RED = 2
  .label BGCOL = $d021
main: {
    // *BGCOL = RED
    lda #RED
    sta BGCOL
    // }
    rts
}
