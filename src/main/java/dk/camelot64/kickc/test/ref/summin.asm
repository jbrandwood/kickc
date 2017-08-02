BBEGIN:
sum_from_BBEGIN:
  lda #2
  lda #1
  jsr sum
B2:
  ldx 2
sum_from_B2:
  lda #13
  lda #9
  jsr sum
B3:
  lda 2
BEND:
sum:
  asl
  sta 2
sum__Breturn:
  rts
