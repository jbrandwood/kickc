// Minimal struct - nested struct where a sub-struct is assigned out
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .const p_x = $a
    .const p_y = $a
    .const c_radius = 5
    lda #p_x
    sta SCREEN
    lda #p_y
    sta SCREEN+1
    lda #c_radius
    sta SCREEN+1
    rts
}
