// Tests a condition type mismatch (not boolean)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    lda #'a'
    sta screen
    rts
}
