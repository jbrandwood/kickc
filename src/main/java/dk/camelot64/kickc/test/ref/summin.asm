  lda #$2
  ldy #$1
  jsr sum
  sta $2
  lda #$4
  ldy #$3
  jsr sum
  tax
  lda #$d
  ldy #$9
  jsr sum
  sta $3
  txa
  clc
  adc $2
  clc
  adc $3
sum: {
    sty $ff
    clc
    adc $ff
    rts
}
