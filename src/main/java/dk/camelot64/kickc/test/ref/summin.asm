BBEGIN:
sum_from_BBEGIN:
  lda #2
  lda #1
  jsr sum
B2:
  stx 2
sum_from_B2:
  lda #13
  lda #9
  jsr sum
B3:
  txa
  clc
  adc 2
BEND:
sum:
  asl
  tax
sum__Breturn:
  rts
