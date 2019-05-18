.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .const w = -1*$100+-1
    lda #<w
    sta screen
    rts
}
