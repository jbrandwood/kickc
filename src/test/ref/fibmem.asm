.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    lda #0
    sta fibs
    lda #1
    sta fibs+1
    ldx #0
  __b1:
    lda fibs,x
    clc
    adc fibs+1,x
    sta fibs+2,x
    inx
    cpx #$f
    bcc __b1
    rts
}
  fibs: .fill $f, 0
