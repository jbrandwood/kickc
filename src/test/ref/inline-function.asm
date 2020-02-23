// Test inline function
// Splits screen so upper half is lower case and lower half lower case
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label D018 = $d018
  .label BGCOL = $d021
  .label screen = $400
  .label charset1 = $1000
  .label charset2 = $1800
main: {
    .const toD0181_return = screen/$40|charset1/$400
    .const toD0182_return = screen/$40|charset2/$400
    // asm
    sei
  __b1:
    // while(*RASTER!=$ff)
    lda #$ff
    cmp RASTER
    bne __b1
    // *D018 = toD018(screen, charset1)
    lda #toD0181_return
    sta D018
    // *BGCOL = $6
    lda #6
    sta BGCOL
  __b2:
    // while(*RASTER!=$62)
    lda #$62
    cmp RASTER
    bne __b2
    // *D018 = toD018(screen, charset2)
    lda #toD0182_return
    sta D018
    // *BGCOL = $b
    lda #$b
    sta BGCOL
    jmp __b1
}
