.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
//  Test a constant with multiplication and division
main: {
    .label screen = $400
    .const b = 6*$e/3+mod($16,3)
    lda #b
    sta screen
    rts
}
