// Tests simple switch()-statement - not inside a loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .const b = 1
    // SCREEN[0] = b
    lda #b
    sta SCREEN
    // }
    rts
}
