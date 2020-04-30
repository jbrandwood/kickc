// Illustrates the problem with variable forward references not working
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const b = 'a'
  .label screen = $400
main: {
    // *screen = b
    lda #b
    sta screen
    // }
    rts
}
