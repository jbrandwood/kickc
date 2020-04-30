// Test that a double-assignment works.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const a = $c
    .label screen = $400
    // screen[0] = a
    lda #a
    sta screen
    // screen[1] = b
    sta screen+1
    // }
    rts
}
