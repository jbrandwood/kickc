// Minimal struct -  using address-of
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    .label q = p
    .label p = 2
    lda #2
    sta.z p
    lda #3
    sta p+OFFSET_STRUCT_POINT_Y
    lda.z q
    sta SCREEN
    lda q+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    rts
}
