// Tests that chained assignments work as intended
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    // screen[0] = a = 'c'
    lda #'c'
    sta screen
    // screen[40] = a
    sta screen+$28
    // screen[1] = 'm'
    lda #'m'
    sta screen+1
    // a = screen[1] = 'm'
    // screen[41] = a
    sta screen+$29
    // screen[2] = 1 + (a = 'l')
    lda #1+'l'
    sta screen+2
    // screen[42] = a
    // Chained assignment with a modification of the result
    lda #'l'
    sta screen+$2a
    // }
    rts
}
