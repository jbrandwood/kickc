// Test an array with mixed byte/number types
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    // SCREEN[0] = msg[0]
    lda msg
    sta SCREEN
    // SCREEN[1] = msg[1]
    lda msg+1
    sta SCREEN+1
    // SCREEN[2] = msg[2]
    lda msg+2
    sta SCREEN+2
    // }
    rts
    msg: .byte 1, 2, 3
}
