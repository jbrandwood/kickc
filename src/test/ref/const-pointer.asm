//Test that constant pointers are detected correctly
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    // screen[0] = '*'
    lda #'*'
    sta screen
    // }
    rts
}
