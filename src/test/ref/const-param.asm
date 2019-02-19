// Test that the compiler optimizes when the same parameter value is passed into a function in all calls
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label reverse = $80
    lda #'c'
    jsr sum
    sta screen
    lda #'m'
    jsr sum
    sta screen+1
    lda #'l'
    jsr sum
    sta screen+2
    rts
}
// sum(byte register(A) b)
sum: {
    clc
    adc #main.reverse
    rts
}
