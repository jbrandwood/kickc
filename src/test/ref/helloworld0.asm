// Tests minimal hello world
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    lda msg,x
    sta SCREEN,x
    inx
    cpx #$c
    bne __b1
    rts
}
  msg: .text "hello world!"
  .byte 0
