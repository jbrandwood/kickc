// Test to provoke Exception when using complex || condition
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label SCREEN = $400
main: {
  b2:
    lda RASTER
    cmp #$20
    beq !+
    bcs b6
  !:
    cmp #$40
    bcc b6
  b7:
    sta SCREEN
    jmp b2
  b6:
    lda #0
    jmp b7
}
