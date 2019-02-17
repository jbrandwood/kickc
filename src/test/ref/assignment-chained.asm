//  Tests that chained assignments work as intended
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    lda #'c'
    sta screen
    sta screen+$28
    lda #'m'
    sta screen+1
    sta screen+$29
    lda #1+'l'
    sta screen+2
    //  Chained assignment with a modification of the result
    lda #'l'
    sta screen+$2a
    rts
}
