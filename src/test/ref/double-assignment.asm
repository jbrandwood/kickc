.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
//  Test that a double-assignment works.
main: {
    .label screen = $400
    .const a = $c
    lda #a
    sta screen
    sta screen+1
    rts
}
