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
    lda #t_c1_center_x
    sta SCREEN
    lda #t_c1_center_y
    sta SCREEN+1
    lda #t_c1_radius
    sta SCREEN+2
    lda #t_c2_center_x
    sta SCREEN+3
    lda #t_c2_center_y
    sta SCREEN+4
    lda #t_c2_radius
    sta SCREEN+5
    rts
}
