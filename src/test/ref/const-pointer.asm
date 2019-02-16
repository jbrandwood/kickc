.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
// Test that constant pointers are detected correctly
main: {
    .label screen = $400
    lda #'*'
    sta screen
    rts
}
