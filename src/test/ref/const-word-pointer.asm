// Test a constant word pointers (pointing to a word placed on zeropage).
// The result when running is "CML!" on the screen.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label wp = w
    .label w = 2
    lda #<$d03
    sta.z w
    lda #>$d03
    sta.z w+1
    lda.z wp
    sta screen
    lda.z wp+1
    sta screen+1
    lda #<$210c
    sta.z wp
    lda #>$210c
    sta.z wp+1
    lda.z wp
    sta screen+2
    lda.z wp+1
    sta screen+3
    rts
}
