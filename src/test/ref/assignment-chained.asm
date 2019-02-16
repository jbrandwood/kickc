.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
//  Tests that chained assignments work as intended
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
    lda #'l'
    sta screen+$2a
    rts
}
