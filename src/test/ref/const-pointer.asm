.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .label screen = $400
    lda #'*'
    sta screen
    rts
}
