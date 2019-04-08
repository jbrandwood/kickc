// Tests the ternary operator - when the condition is constant
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    lda #'a'
    sta SCREEN
    lda #'b'
    sta SCREEN+1
    rts
}
