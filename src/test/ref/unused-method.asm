.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    // screen[0] = 1
    lda #1
    sta screen
    // }
    rts
}
