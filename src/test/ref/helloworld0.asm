// Tests minimal hello world
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  b1:
    lda msg,x
    sta SCREEN,x
    inx
    cpx #$c
    bne b1
    rts
}
  msg: .text "hello world!@"
