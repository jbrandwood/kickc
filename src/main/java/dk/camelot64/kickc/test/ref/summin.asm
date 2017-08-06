BBEGIN:
sum_from_BBEGIN:
  lda #2
  ldx #1
  jsr sum
B2:
  sta 2
sum_from_B2:
  lda #13
  ldx #9
  jsr sum
B3:
  clc
  adc 2
BEND:
sum:
  stx 255
  clc
  adc 255
sum__Breturn:
  rts
