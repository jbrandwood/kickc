.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label buf = $1100
    ldx #5
  __b1:
    txa
    clc
    adc #2+2
    sta buf,x
    inx
    cpx #$a
    bcc __b1
    rts
}
