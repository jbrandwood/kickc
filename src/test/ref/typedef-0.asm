.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const b = 'a'
    .label SCREEN = $400
    lda #b
    sta SCREEN
    rts
}