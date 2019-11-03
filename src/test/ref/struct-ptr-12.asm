// Minimal struct -  using address-of
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    .label q = p_x
    .label p_x = 2
    .label p_y = 3
    lda #2
    sta.z p_x
    lda #3
    sta.z p_y
    lda.z q
    sta SCREEN
    lda q+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    rts
}
