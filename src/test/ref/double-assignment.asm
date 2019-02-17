// Test that a double-assignment works.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .const a = $c
    lda #a
    sta screen
    sta screen+1
    rts
}
