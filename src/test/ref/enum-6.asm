// Test of simple enum - anonymous enum definition
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const OFF = 0
    .const ON = 1
    .label SCREEN = $400
    lda #ON
    sta SCREEN
    lda #OFF
    sta SCREEN+1
    rts
}
