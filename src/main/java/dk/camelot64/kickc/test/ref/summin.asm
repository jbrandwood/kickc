  .label s1 = 2
  .label s3 = 3
  lda #2
  ldy #1
  jsr sum
  sta s1
  lda #4
  ldy #3
  jsr sum
  tax
  lda #$d
  ldy #9
  jsr sum
  sta s3
  txa
  clc
  adc s1
  clc
  adc s3
sum: {
    sty $ff
    clc
    adc $ff
    rts
}
