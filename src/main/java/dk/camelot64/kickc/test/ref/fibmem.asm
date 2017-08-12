bbegin:
  jsr main
bend:
main: {
    lda #$0
    sta $1100
    lda #$1
    sta $1101
  b1_from_main:
    ldx #$0
  b1_from_b1:
  b1:
    lda $1100,x
    clc
    adc $1101,x
    sta $1102,x
    inx
    cpx #$f
    bcc b1_from_b1
  breturn:
    rts
}
