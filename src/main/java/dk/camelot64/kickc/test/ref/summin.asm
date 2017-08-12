BBEGIN:
sum_from_BBEGIN:
  lda #$2
  ldy #$1
  jsr sum
B2:
  sta $2
sum_from_B2:
  lda #$4
  ldy #$3
  jsr sum
B3:
  tax
sum_from_B3:
  lda #$d
  ldy #$9
  jsr sum
B4:
  sta $3
  txa
  clc
  adc $2
  clc
  adc $3
BEND:
sum:
  sty $ff
  clc
  adc $ff
sum__Breturn:
  rts
