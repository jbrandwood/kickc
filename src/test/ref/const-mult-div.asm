// Test a constant with multiplication and division
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const b = $19
    .label screen = $400
    lda #b
    sta screen
    rts
}
