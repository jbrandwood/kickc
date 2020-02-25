.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // fibs[0] = 0
    lda #0
    sta fibs
    // fibs[1] = 1
    lda #1
    sta fibs+1
    ldx #0
  __b1:
    // fibs[i]+fibs[i+1]
    lda fibs,x
    clc
    adc fibs+1,x
    // fibs[i+2] = fibs[i]+fibs[i+1]
    sta fibs+2,x
    // while(++i<15)
    inx
    cpx #$f
    bcc __b1
    // }
    rts
}
  fibs: .fill $f, 0
