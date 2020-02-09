.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINTDEF_Y = 1
main: {
    .label SCREEN = $400
    .const p_x = 4
    .const p_y = 7
    lda #p_x
    sta SCREEN
    lda #p_y
    sta SCREEN+OFFSET_STRUCT_POINTDEF_Y
    rts
}
