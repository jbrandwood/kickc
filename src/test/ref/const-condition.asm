.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
//  Ensure that if()'s with constant comparisons are identified and eliminated
main: {
    .label SCREEN = $400
    lda #'!'
    sta SCREEN
    rts
}
