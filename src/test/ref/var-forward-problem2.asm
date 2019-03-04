// Illustrates the problem with variable forward references not working
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
  .const b = 'a'
main: {
    lda #b
    sta screen
    rts
}
