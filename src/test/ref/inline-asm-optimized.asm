// Tests that inline assembler is optimized
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    lda #0
    sta SCREEN
    sta SCREEN+1
    sta SCREEN+2
    sta SCREEN+3
    sta SCREEN+4
    rts
}
