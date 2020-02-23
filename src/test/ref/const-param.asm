// Test that the compiler optimizes when the same parameter value is passed into a function in all calls
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label reverse = $80
    .label screen = $400
    // sum(reverse, 'c')
    lda #'c'
    jsr sum
    // sum(reverse, 'c')
    // screen[0] = sum(reverse, 'c')
    sta screen
    // sum(reverse, 'm')
    lda #'m'
    jsr sum
    // sum(reverse, 'm')
    // screen[1] = sum(reverse, 'm')
    sta screen+1
    // sum(reverse, 'l')
    lda #'l'
    jsr sum
    // sum(reverse, 'l')
    // screen[2] = sum(reverse, 'l')
    sta screen+2
    // }
    rts
}
// sum(byte register(A) b)
sum: {
    // a+b
    clc
    adc #main.reverse
    // }
    rts
}
