  jsr main
main: {
    ldx #$64
  b1:
    lda #$0
  b2:
    sta $400,x
    clc
    adc #$1
    sta $ff
    cpx $ff
    bne b2
    dex
    cpx #$1
    bne b1
    rts
}
