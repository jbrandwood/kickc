// Minimal struct - nesting structs
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .const p_x = $a
    .const p_y = $a
    .const c_radius = $c
    // SCREEN[0] = c.center.x
    lda #p_x
    sta SCREEN
    // SCREEN[1] = c.center.y
    lda #p_y
    sta SCREEN+1
    // SCREEN[2] = c.radius
    lda #c_radius
    sta SCREEN+2
    // }
    rts
}
