.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const RED = 2
  .label BGCOL = $d021
main: {
    .label screen = $400
    // *screen = 1
    lda #1
    sta screen
    // *BGCOL = RED
    lda #RED
    sta BGCOL
    // }
    rts
}
