// Minimal struct - initializing using a value list
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .const x = 2
    .const y = 3
    .const p_y = y+1
    // SCREEN[0] = p.x
    lda #x
    sta SCREEN
    // SCREEN[1] = p.y
    lda #p_y
    sta SCREEN+1
    // }
    rts
}
