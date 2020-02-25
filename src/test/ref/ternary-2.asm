// Tests the ternary operator - when the condition is constant
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    // SCREEN[0] = true?'a':'b'
    lda #'a'
    sta SCREEN
    // SCREEN[1] = false?'a':'b'
    lda #'b'
    sta SCREEN+1
    // }
    rts
}
