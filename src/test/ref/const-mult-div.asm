// Test a constant with multiplication and division
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const b = 6*$e/3+mod($16,3)
    .label screen = $400
    // screen[0] = b
    lda #b
    sta screen
    // }
    rts
}
