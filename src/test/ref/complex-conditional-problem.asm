// Test to provoke Exception when using complex || condition
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label SCREEN = $400
main: {
  b1:
    lda RASTER
    cmp #$20
    beq !+
    bcs b3
  !:
    cmp #$40
    bcc b3
  b2:
    sta SCREEN
    jmp b1
  b3:
    lda #0
    jmp b2
}
