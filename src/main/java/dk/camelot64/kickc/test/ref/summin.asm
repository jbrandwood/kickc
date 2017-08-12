bbegin:
sum_from_bbegin:
  lda #$2
  ldy #$1
  jsr sum
b2:
  sta $2
sum_from_b2:
  lda #$4
  ldy #$3
  jsr sum
b3:
  tax
sum_from_b3:
  lda #$d
  ldy #$9
  jsr sum
b4:
  sta $3
  txa
  clc
  adc $2
  clc
  adc $3
bend:
sum: {
    sty $ff
    clc
    adc $ff
  breturn:
    rts
}
