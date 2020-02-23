.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label buf = $1100
    ldx #5
  __b1:
    // 2+i+2
    txa
    clc
    adc #2+2
    // buf[i] = 2+i+2
    sta buf,x
    // i = i+1
    inx
    // while(i<10)
    cpx #$a
    bcc __b1
    // }
    rts
}
