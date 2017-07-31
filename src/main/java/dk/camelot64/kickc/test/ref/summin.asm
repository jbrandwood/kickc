BBEGIN:
sum_from_BBEGIN:
  lda #2
  sta 3
  lda #1
  sta 2
  jsr sum
B2:
  lda 2
  sta 4
sum_from_B2:
  lda #13
  sta 3
  lda #9
  sta 2
  jsr sum
B3:
  lda 2
  sta 5
  lda 4
  clc
  adc 5
  sta 4
BEND:
sum:
  lda 2
  clc
  adc 3
  sta 2
sum__Breturn:
  rts
