.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // *SCREEN = 1
    lda #1
    sta SCREEN
    // }
    rts
}
