.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  jsr main
main: {
    lda #1
    sta SCREEN
    rts
}
