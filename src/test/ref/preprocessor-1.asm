.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // *SCREEN = 'a'
    lda #'a'
    sta SCREEN
    // END_MAIN
    rts
}
