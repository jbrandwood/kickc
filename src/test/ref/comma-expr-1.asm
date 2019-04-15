// Tests simple comma-expression (in parenthesis)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .const b = 3
    .const c = b+1
    lda #c
    sta SCREEN
    rts
}
