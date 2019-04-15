// Tests that immediate zero values are reused - even when assigning to words
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label w = 2
    ldx #0
    txa
    sta w
    sta w+1
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
