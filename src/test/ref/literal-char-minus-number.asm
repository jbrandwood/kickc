// Tests subtracting a number from a literal char
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    lda #'a'-1
    sta SCREEN
    rts
}
