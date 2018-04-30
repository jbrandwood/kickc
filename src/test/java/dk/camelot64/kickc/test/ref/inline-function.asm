.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label D018 = $d018
  .label BGCOL = $d021
  .label screen = $400
  .label charset1 = $1000
  .label charset2 = $1800
  jsr main
main: {
    .const toD0181_return = screen/$40|charset1/$400
    .const toD0182_return = screen/$40|charset2/$400
    sei
  b4:
    lda RASTER
    cmp #$ff
    bne b4
    lda #toD0181_return
    sta D018
    lda #6
    sta BGCOL
  b7:
    lda RASTER
    cmp #$62
    bne b7
    lda #toD0182_return
    sta D018
    lda #$b
    sta BGCOL
    jmp b4
}
