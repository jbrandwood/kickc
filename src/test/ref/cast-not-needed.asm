// Tests a cast that is not needed
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label sprite = $5000
  .label SCREEN = $4400
main: {
    .label sprite_ptr = SCREEN+$378
    lda #$ff&sprite/$40
    sta sprite_ptr
    rts
}
