.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .label w = 2
    lda #<0
    sta w
    sta w+1
    tax
  b1:
    txa
    clc
    adc w
    sta w
    bcc !+
    inc w+1
  !:
    inx
    cpx #$b
    bne b1
    rts
}
