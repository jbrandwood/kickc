// Tests simple comma-expression (in parenthesis)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .const b = 3
    .const c = b+1
    // SCREEN[1,0] = c
    lda #c
    sta SCREEN
    // }
    rts
}
