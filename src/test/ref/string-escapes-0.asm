// Test using some simple supported string escapes \r \f \n \' \"
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldy #0
  b1:
    lda #0
    cmp MESSAGE,y
    bne b2
    rts
  b2:
    lda MESSAGE,y
    sta SCREEN,y
    iny
    jmp b1
}
  MESSAGE: .text @"\r\f\n\"'"
  .byte 0
