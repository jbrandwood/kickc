// Ensure that if()'s with constant comparisons are identified and eliminated
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    // SCREEN[0] = '!'
    lda #'!'
    sta SCREEN
    // }
    rts
}
