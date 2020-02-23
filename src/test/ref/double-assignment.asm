// Test that a double-assignment works.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .const a = $c
    // screen[0] = a
    lda #a
    sta screen
    // screen[1] = b
    sta screen+1
    // }
    rts
}
