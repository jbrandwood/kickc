// Test of simple enum - multiple inline enum definitions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const ON = 1
    .label SCREEN = $400
    lda #ON
    sta SCREEN
    jsr test
    rts
}
test: {
    .const ON = 8
    .label SCREEN = $428
    lda #ON
    sta SCREEN
    rts
}
