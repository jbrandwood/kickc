// Minimal struct -  using address-of and passing it to a function
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label q = p_x
    .label SCREEN = $400
    .label p_x = 2
    .label p_y = 3
    lda #2
    sta p_x
    lda #3
    sta p_y
    jsr set
    lda q
    sta SCREEN
    lda q+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    rts
}
set: {
    lda #4
    sta main.q
    lda #5
    sta main.q+OFFSET_STRUCT_POINT_Y
    rts
}
