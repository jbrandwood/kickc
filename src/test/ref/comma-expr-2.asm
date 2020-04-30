// Tests simple comma-expressions (without parenthesis)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const c = 1+3
    .label SCREEN = $400
    // SCREEN[1,0] = c
    lda #c
    sta SCREEN
    // }
    rts
}
