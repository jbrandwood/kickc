// Tests literal strings with and without zero-termination
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    lda msg,x
    sta SCREEN,x
    lda msgz,x
    sta SCREEN+$28,x
    inx
    cpx #4
    bne __b1
    rts
}
  msgz: .text "cml"
  msg: .text "cml"
  .byte 0
