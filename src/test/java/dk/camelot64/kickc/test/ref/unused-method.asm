.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .const screen = $400
    lda #1
    sta screen+0
    rts
}
