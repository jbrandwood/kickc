// Illustrates problem with negating a constant negative number
// KickAsm requires parenthesis for double negation to work
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // printneg(-4)
    jsr printneg
    // }
    rts
}
printneg: {
    // SCREEN[0] = c
    lda #-(-4)
    sta SCREEN
    // }
    rts
}
