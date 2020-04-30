// Tests simple switch()-statement - not inside a loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const b = 1
    .label SCREEN = $400
    // SCREEN[0] = b
    lda #b
    sta SCREEN
    // }
    rts
}
