  jsr main
main: {
    .const buf = $1100
    ldx #5
  b1:
    txa
    clc
    adc #2+2
    sta buf,x
    inx
    cpx #$a
    bcc b1
    rts
}
