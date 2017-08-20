  .label s1 = 2
  lda #$2
  ldy #$1
  jsr sum
  sta s1
  lda #$4
  ldy #$3
  jsr sum
  tax
  lda #$d
  ldy #$9
  jsr sum
  tay
  txa
  clc
  adc s1
  sty $ff
  clc
  adc $ff
sum: {
    sty $ff
    clc
    adc $ff
    rts
}
