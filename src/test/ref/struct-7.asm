// Minimal struct - nesting structs 3 levels
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .const t_c1_radius = 3
    .const t_c2_radius = 6
    .const t_c1_center_x = 1
    .const t_c1_center_y = 2
    .const t_c2_center_x = 4
    .const t_c2_center_y = 5
    // SCREEN[0] = t.c1.center.x
    lda #t_c1_center_x
    sta SCREEN
    // SCREEN[1] = t.c1.center.y
    lda #t_c1_center_y
    sta SCREEN+1
    // SCREEN[2] = t.c1.radius
    lda #t_c1_radius
    sta SCREEN+2
    // SCREEN[3] = t.c2.center.x
    lda #t_c2_center_x
    sta SCREEN+3
    // SCREEN[4] = t.c2.center.y
    lda #t_c2_center_y
    sta SCREEN+4
    // SCREEN[5] = t.c2.radius
    lda #t_c2_radius
    sta SCREEN+5
    // }
    rts
}
