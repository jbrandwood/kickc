.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
  .const b = 'a'
  jsr main
main: {
    lda #b
    sta screen
    rts
}
