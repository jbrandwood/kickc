.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // SCREEN[0] = *fileCur
    lda $1010-1
    sta SCREEN
    // }
    rts
}
