// Test using some simple supported string escapes \r \f \n \' \"
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  b1:
    lda MESSAGE,x
    cmp #0
    bne b2
    rts
  b2:
    lda MESSAGE,x
    sta SCREEN,x
    inx
    jmp b1
}
  MESSAGE: .text @"\r\f\n\"'\\"
  .byte 0
