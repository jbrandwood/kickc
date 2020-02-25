// Tests minimal hello world
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
    // for( byte i: 0..11)
    inx
    cpx #$c
    bne __b1
    // }
    rts
}
  msg: .text "hello world!"
  .byte 0
