// Tests simple comma-expressions (without parenthesis)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .const c = 1+3
    lda #c
    sta SCREEN
    rts
}
