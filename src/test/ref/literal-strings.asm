// Tests literal strings with and without zero-termination
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    // SCREEN[i] = msg[i]
    lda msg,x
    sta SCREEN,x
    // (SCREEN+40)[i] = msgz[i]
    lda msgz,x
    sta SCREEN+$28,x
    // for( byte i:0..3)
    inx
    cpx #4
    bne __b1
    // }
    rts
}
  msgz: .text "cml"
  msg: .text "cml"
  .byte 0
