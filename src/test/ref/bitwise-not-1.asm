// Test that bitwise NOT (~) is handled correctly
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const b = $10^$ff
    .label screen = $400
    // *screen = b
    lda #b
    sta screen
    // }
    rts
}
