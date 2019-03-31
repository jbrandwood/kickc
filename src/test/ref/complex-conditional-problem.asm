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
    bcs b2
  !:
    cmp #$40
    bcc b2
  b3:
    sta SCREEN
    jmp b1
  b2:
    lda #0
    jmp b3
}
