// Test an array with mixed byte/number types
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    lda msg
    sta SCREEN
    lda msg+1
    sta SCREEN+1
    lda msg+2
    sta SCREEN+2
    rts
    msg: .byte 1, 2, 3
}
