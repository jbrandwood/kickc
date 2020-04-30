// Minimal struct - nested struct where a sub-struct is assigned out
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const p_x = $a
    .const p_y = $a
    .const c_radius = 5
    .label SCREEN = $400
    // SCREEN[0] = point.x
    lda #p_x
    sta SCREEN
    // SCREEN[1] = point.y
    lda #p_y
    sta SCREEN+1
    // SCREEN[1] = c.radius
    lda #c_radius
    sta SCREEN+1
    // }
    rts
}
