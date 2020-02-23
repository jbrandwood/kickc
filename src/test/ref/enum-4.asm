// Test of simple enum - inline enum definitions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const ON = 1
    .label SCREEN = $400
    // *SCREEN = state
    lda #ON
    sta SCREEN
    // }
    rts
}
