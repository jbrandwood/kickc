// Test to provoke Exception when using complex || condition
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label SCREEN = $400
main: {
  __b1:
    // key = *RASTER
    lda RASTER
    // if (key > $20 || key < $40)
    cmp #$20+1
    bcs b1
    cmp #$40
    bcs __b2
  b1:
    lda #0
  __b2:
    // *SCREEN = key
    sta SCREEN
    jmp __b1
}
