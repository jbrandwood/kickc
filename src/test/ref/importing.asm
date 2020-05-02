.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const RED = 2
  .label BG_COLOR = $d021
main: {
    .label screen = $400
    // *screen = 1
    lda #1
    sta screen
    // *BG_COLOR = RED
    lda #RED
    sta BG_COLOR
    // }
    rts
}
