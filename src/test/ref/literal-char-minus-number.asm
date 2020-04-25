// Tests subtracting a number from a literal char
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    // *SCREEN = 'a' - 1
    lda #0
    sta SCREEN
    // }
    rts
}
