// Test a constant word pointers (pointing to a word placed on zeropage).
// The result when running is "CML!" on the screen.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label wp = w
    .label w = 2
    // w = $0d03
    lda #<$d03
    sta.z w
    lda #>$d03
    sta.z w+1
    // <*wp
    lda.z wp
    // screen[0] = <*wp
    sta screen
    // >*wp
    lda.z wp+1
    // screen[1] = >*wp
    sta screen+1
    // *wp = $210c
    lda #<$210c
    sta.z wp
    lda #>$210c
    sta.z wp+1
    // <*wp
    lda.z wp
    // screen[2] = <*wp
    sta screen+2
    // >*wp
    lda.z wp+1
    // screen[3] = >*wp
    sta screen+3
    // }
    rts
}
