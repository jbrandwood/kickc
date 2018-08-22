.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label fibs = $1100
  jsr main
main: {
    lda #0
    sta fibs
    lda #1
    sta fibs+1
    ldx #0
  b1:
    lda fibs,x
    clc
    adc fibs+1,x
    sta fibs+2,x
    inx
    cpx #$f
    bcc b1
    rts
}
