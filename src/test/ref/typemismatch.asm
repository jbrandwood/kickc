// Type mismatch - should fail gracefully
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .const w = $1388
    .const b = $ff&w
    lda #b
    sta screen
    rts
}
